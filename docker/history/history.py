from datetime import datetime, timedelta
from steem import Steem
from pymongo import MongoClient
from pprint import pprint
import collections
import time
import sys
import os
import re

from apscheduler.schedulers.background import BackgroundScheduler

fullnodes = [
    'https://api.steemit.com',
]
rpc = Steem(fullnodes)
mongo = MongoClient("mongodb://192.168.0.1")
db = mongo.steemdb

mvest_per_account = {}

def load_accounts():
    pprint("[STEEM] - Loading mvest per account")
    for account in db.account.find():
        if "name" in account.keys():
            mvest_per_account.update({account['name']: account['vesting_shares']})

def update_fund_history():
    pprint("[STEEM] - Update Fund History")

    fund = rpc.get_reward_fund('post')
    for key in ['recent_claims', 'content_constant']:
        fund[key] = float(fund[key])
    for key in ['reward_balance']:
        fund[key] = float(fund[key].split()[0])
    for key in ['last_update']:
        fund[key] = datetime.strptime(fund[key], "%Y-%m-%dT%H:%M:%S")

    db.funds_history.insert(fund)

def update_props_history():
    pprint("[STEEM] - Update Global Properties")

    props = rpc.get_dynamic_global_properties()

    for key in ['max_virtual_bandwidth', 'recent_slots_filled', 'total_reward_shares2']:
        props[key] = float(props[key])
    for key in ['confidential_sbd_supply', 'confidential_supply', 'current_sbd_supply', 'current_supply', 'total_reward_fund_steem', 'total_vesting_fund_steem', 'total_vesting_shares', 'virtual_supply']:
        props[key] = float(props[key].split()[0])
    for key in ['time']:
        props[key] = datetime.strptime(props[key], "%Y-%m-%dT%H:%M:%S")

    #floor($return['total_vesting_fund_steem'] / $return['total_vesting_shares'] * 1000000 * 1000) / 1000;

    props['steem_per_mvests'] = props['total_vesting_fund_steem'] / props['total_vesting_shares'] * 1000000

    db.status.update({
      '_id': 'steem_per_mvests'
    }, {
      '$set': {
        '_id': 'steem_per_mvests',
        'value': props['steem_per_mvests']
      }
    }, upsert=True)

    db.status.update({
      '_id': 'props'
    }, {
      '$set': {
        '_id': 'props',
        'props': props
      }
    }, upsert=True)

    db.props_history.insert(props)

def update_tx_history():
    pprint("[STEEM] - Update Transaction History")
    now = datetime.now().date()

    today = datetime.combine(now, datetime.min.time())
    yesterday = today - timedelta(1)

    # Determine tx per day
    query = {
      '_ts': {
        '$gte': today,
        '$lte': today + timedelta(1)
      }
    }
    count = db.block_30d.count(query)

    pprint(count)

    pprint(now)
    pprint(today)
    pprint(yesterday)



def update_history():

    update_fund_history()
    update_props_history()
    # update_tx_history()
    # sys.stdout.flush()

    # Load all accounts
    users = rpc.lookup_accounts(-1, 1000)
    more = True
    while more:
        newUsers = rpc.lookup_accounts(users[-1], 1000)
        if len(newUsers) < 1000:
            more = False
        users = users + newUsers

    # Set dates
    now = datetime.now().date()
    today = datetime.combine(now, datetime.min.time())

    pprint("[STEEM] - Update History (" + str(len(users)) + " accounts)")
    # Snapshot User Count
    db.statistics.update({
      'key': 'users',
      'date': today,
    }, {
      'key': 'users',
      'date': today,
      'value': len(users)
    }, upsert=True)
    sys.stdout.flush()

    # Update history on accounts
    for user in users:
        # Load State
        state = rpc.get_accounts([user])
        # Get Account Data
        account = collections.OrderedDict(sorted(state[0].items()))
        # Get followers
        account['followers'] = []
        account['followers_count'] = 0
        account['followers_mvest'] = 0
        followers_results = rpc.get_followers(user, "", "blog", 100, api="follow")
        while followers_results:
          last_account = ""
          for follower in followers_results:
            last_account = follower['follower']
            if 'blog' in follower['what'] or 'posts' in follower['what']:
              account['followers'].append(follower['follower'])
              account['followers_count'] += 1
              if follower['follower'] in mvest_per_account.keys():
                account['followers_mvest'] += float(mvest_per_account[follower['follower']])
          followers_results = rpc.get_followers(user, last_account, "blog", 100, api="follow")[1:]
        # Get following
        account['following'] = []
        account['following_count'] = 0
        following_results = rpc.get_following(user, -1, "blog", 100, api="follow")
        while following_results:
          last_account = ""
          for following in following_results:
            last_account = following['following']
            if 'blog' in following['what'] or 'posts' in following['what']:
              account['following'].append(following['following'])
              account['following_count'] += 1
          following_results = rpc.get_following(user, last_account, "blog", 100, api="follow")[1:]
        # Convert to Numbers
        account['proxy_witness'] = sum(float(i) for i in account['proxied_vsf_votes']) / 1000000
        for key in ['lifetime_bandwidth', 'reputation', 'to_withdraw']:
            account[key] = float(account[key])
        for key in ['balance', 'sbd_balance', 'sbd_seconds', 'savings_balance', 'savings_sbd_balance', 'vesting_balance', 'vesting_shares', 'vesting_withdraw_rate']:
            account[key] = float(account[key].split()[0])
        # Convert to Date
        for key in ['created','last_account_recovery','last_account_update','last_active_proved','last_bandwidth_update','last_market_bandwidth_update','last_owner_proved','last_owner_update','last_post','last_root_post','last_vote_time','next_vesting_withdrawal','savings_sbd_last_interest_payment','savings_sbd_seconds_last_update','sbd_last_interest_payment','sbd_seconds_last_update']:
            account[key] = datetime.strptime(account[key], "%Y-%m-%dT%H:%M:%S")
        # Combine Savings + Balance
        account['total_balance'] = account['balance'] + account['savings_balance']
        account['total_sbd_balance'] = account['sbd_balance'] + account['savings_sbd_balance']
        # Update our current info about the account
        mvest_per_account.update({account['name']: account['vesting_shares']})
        # Save current state of account
        account['scanned'] = datetime.now()
        db.account.update({'_id': user}, account, upsert=True)
        # Create our Snapshot dict
        wanted_keys = ['name', 'proxy_witness', 'activity_shares', 'average_bandwidth', 'average_market_bandwidth', 'savings_balance', 'balance', 'comment_count', 'curation_rewards', 'lifetime_bandwidth', 'lifetime_vote_count', 'next_vesting_withdrawal', 'reputation', 'post_bandwidth', 'post_count', 'posting_rewards', 'sbd_balance', 'savings_sbd_balance', 'sbd_last_interest_payment', 'sbd_seconds', 'sbd_seconds_last_update', 'to_withdraw', 'vesting_balance', 'vesting_shares', 'vesting_withdraw_rate', 'voting_power', 'withdraw_routes', 'withdrawn', 'witnesses_voted_for']
        snapshot = dict((k, account[k]) for k in wanted_keys if k in account)
        snapshot.update({
          'account': user,
          'date': today,
          'followers': len(account['followers']),
          'following': len(account['following']),
        })
        # Save Snapshot in Database
        db.account_history.update({
          'account': user,
          'date': today
        }, snapshot, upsert=True)

def update_stats():
  pprint("updating stats");
  # Calculate Transactions
  results = db.block_30d.aggregate([
    {
      '$sort': {
        '_id': -1
      }
    },
    {
      '$limit': 28800 * 1
    },
    {
      '$unwind': '$transactions'
    },
    {
      '$group': {
        '_id': '24h',
        'tx': {
          '$sum': 1
        }
      }
    }
  ])
  data = list(results)[0]['tx']
  db.status.update({'_id': 'transactions-24h'}, {'$set': {'data' : data}}, upsert=True)
  now = datetime.now().date()
  today = datetime.combine(now, datetime.min.time())
  db.tx_history.update({
    'timeframe': '24h',
    'date': today
  }, {'$set': {'data': data}}, upsert=True)

  results = db.block_30d.aggregate([
    {
      '$sort': {
        '_id': -1
      }
    },
    {
      '$limit': 1200 * 1
    },
    {
      '$unwind': '$transactions'
    },
    {
      '$group': {
        '_id': '1h',
        'tx': {
          '$sum': 1
        }
      }
    }
  ])
  db.status.update({'_id': 'transactions-1h'}, {'$set': {'data' : list(results)[0]['tx']}}, upsert=True)

  # Calculate Operations
  results = db.block_30d.aggregate([
    {
      '$sort': {
        '_id': -1
      }
    },
    {
      '$limit': 28800 * 1
    },
    {
      '$unwind': '$transactions'
    },
    {
      '$group': {
        '_id': '24h',
        'tx': {
          '$sum': {
            '$size': '$transactions.operations'
          }
        }
      }
    }
  ])
  data = list(results)[0]['tx']
  db.status.update({'_id': 'operations-24h'}, {'$set': {'data' : data}}, upsert=True)
  now = datetime.now().date()
  today = datetime.combine(now, datetime.min.time())
  db.op_history.update({
    'timeframe': '24h',
    'date': today
  }, {'$set': {'data': data}}, upsert=True)

  results = db.block_30d.aggregate([
    {
      '$sort': {
        '_id': -1
      }
    },
    {
      '$limit': 1200 * 1
    },
    {
      '$unwind': '$transactions'
    },
    {
      '$group': {
        '_id': '1h',
        'tx': {
          '$sum': {
            '$size': '$transactions.operations'
          }
        }
      }
    }
  ])
  db.status.update({'_id': 'operations-1h'}, {'$set': {'data' : list(results)[0]['tx']}}, upsert=True)


def update_clients():
  try:
    pprint("updating clients");
    start = datetime.today() - timedelta(days=90)
    end = datetime.today()
    regx = re.compile("([\w-]+\/[\w.]+)", re.IGNORECASE)
    results = db.comment.aggregate([
      {
        '$match': {
          'created': {
            '$gte': start,
            '$lte': end,
          },
          'json_metadata.app': {
            '$type': 'string',
            '$regex': regx,
          }
        }
      },
      {
        '$project': {
          'created': '$created',
          'parts': {
            '$split': ['$json_metadata.app', '/']
          },
          'reward': {
            '$add': ['$total_payout_value', '$pending_payout_value', '$total_pending_payout_value']
          }
        }
      },
      {
        '$group': {
          '_id': {
            'client': {'$arrayElemAt': ['$parts', 0]},
            'doy': {'$dayOfYear': '$created'},
            'year': {'$year': '$created'},
            'month': {'$month': '$created'},
            'day': {'$dayOfMonth': '$created'},
            'dow': {'$dayOfWeek': '$created'},
          },
          'reward': {'$sum': '$reward'},
          'value': {'$sum': 1}
        }
      },
      {
        '$sort': {
          '_id.year': 1,
          '_id.doy': 1,
          'value': -1,
        }
      },
      {
        '$group': {
          '_id': {
            'doy': '$_id.doy',
            'year': '$_id.year',
            'month': '$_id.month',
            'day': '$_id.day',
            'dow': '$_id.dow',
          },
          'clients': {
            '$push': {
              'client': '$_id.client',
              'count': '$value',
              'reward': '$reward'
            }
          },
          'reward' : {
            '$sum': '$reward'
          },
          'total': {
            '$sum': '$value'
          }
        }
      },
      {
        '$sort': {
          '_id.year': -1,
          '_id.doy': -1
        }
      },
    ])
    pprint("complete")
    sys.stdout.flush()
    data = list(results)
    db.status.update({'_id': 'clients-snapshot'}, {'$set': {'data' : data}}, upsert=True)
    now = datetime.now().date()
    today = datetime.combine(now, datetime.min.time())
    db.clients_history.update({
      'date': today
    }, {'$set': {'data': data}}, upsert=True)
    pass
  except Exception as e:
    pass


if __name__ == '__main__':
    pprint("starting");
    # Load all account data into memory

    # Start job immediately
    update_clients()
    update_props_history()
    load_accounts()
    update_stats()
    # update_history()
    sys.stdout.flush()

    # Schedule it to run every 6 hours
    scheduler = BackgroundScheduler()
    scheduler.add_job(update_history, 'interval', hours=24, id='update_history')
    scheduler.add_job(update_clients, 'interval', hours=1, id='update_clients')
    scheduler.add_job(update_stats, 'interval', minutes=5, id='update_stats')
    scheduler.start()
    # Loop
    try:
        while True:
            time.sleep(2)
    except (KeyboardInterrupt, SystemExit):
        scheduler.shutdown()
