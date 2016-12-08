from datetime import datetime
from steemapi.steemnoderpc import SteemNodeRPC
from piston.steem import Post
from pymongo import MongoClient
from pprint import pprint
import collections
import time
import sys
import os

from apscheduler.schedulers.background import BackgroundScheduler

# rpc = SteemNodeRPC(host, "", "", ['follow_api'])

rpc = SteemNodeRPC("ws://" + os.environ['steemnode'], "", "", apis=["follow", "database"])
mongo = MongoClient("mongodb://mongo")
db = mongo.steemdb

mvest_per_account = {}

def load_accounts():
    pprint("SteemDB - Loading mvest per account")
    for account in db.account.find():
        mvest_per_account.update({account['name']: account['vesting_shares']})

def update_history():

    pprint("SteemDB - Update Global Properties")

    props = rpc.get_dynamic_global_properties()

    for key in ['max_virtual_bandwidth', 'recent_slots_filled', 'total_reward_shares2']:
        props[key] = float(props[key])
    for key in ['confidential_sbd_supply', 'confidential_supply', 'current_sbd_supply', 'current_supply', 'total_reward_fund_steem', 'total_vesting_fund_steem', 'total_vesting_shares', 'virtual_supply']:
        props[key] = float(props[key].split()[0])
    for key in ['time']:
        props[key] = datetime.strptime(props[key], "%Y-%m-%dT%H:%M:%S")

    db.props_history.insert(props)

    users = rpc.lookup_accounts(-1, 1000)
    more = True
    # more = False
    while more:
        newUsers = rpc.lookup_accounts(users[-1], 1000)
        if len(newUsers) < 1000:
            more = False
        users = users + newUsers

    now = datetime.now().date()
    today = datetime.combine(now, datetime.min.time())
    pprint("SteemDB - Update History (" + str(len(users)) + " accounts)")
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

if __name__ == '__main__':
    # Load all account data into memory
    load_accounts()
    # Start job immediately
    update_history()
    # Schedule it to run every 6 hours
    scheduler = BackgroundScheduler()
    scheduler.add_job(update_history, 'interval', hours=6, id='update_history')
    scheduler.start()
    # Loop
    try:
        while True:
            time.sleep(2)
    except (KeyboardInterrupt, SystemExit):
        scheduler.shutdown()
