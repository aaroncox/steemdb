from datetime import datetime, timedelta
from steem import Steem
from pymongo import MongoClient
from pprint import pprint
import collections
import json
import time
import sys
import os

fullnodes = [
    'https://api.steemit.com',
]
rpc = Steem(fullnodes)
mongo = MongoClient("mongodb://192.168.0.1")
db = mongo.steemdb

init = db.status.find_one({'_id': 'height'})
if(init):
  last_block = init['value']
else:
  last_block = 1

# ------------
# For development:
#
# If you're looking for a faster way to sync the data and get started,
# uncomment this line with a more recent block, and the chain will start
# to sync from that point onwards. Great for a development environment
# where you want some data but don't want to sync the entire blockchain.
# ------------

# last_block = 12766938

def process_op(opObj, block, blockid):
    opType = opObj[0]
    op = opObj[1]
    if opType == "comment":
        # Update the comment
        update_comment(op['author'], op['permlink'], op, block, blockid)
    if opType == "comment_options":
        update_comment_options(op, block, blockid)
    if opType == "vote":
        # Update the comment and vote
        # update_comment(op['author'], op['permlink'])
        save_vote(op, block, blockid)
    if opType =="convert":
        save_convert(op, block, blockid)
    if opType == "comment_benefactor_reward":
        save_benefactor_reward(op, block, blockid)
    if opType == "custom_json":
        save_custom_json(op, block, blockid)
    if opType == "feed_publish":
        save_feed_publish(op, block, blockid)
    if opType == "account_witness_vote":
        save_witness_vote(op, block, blockid)
    if opType == "pow" or opType == "pow2":
        save_pow(op, block, blockid)
    if opType == "transfer":
        save_transfer(op, block, blockid)
    if opType == "curation_reward":
        save_curation_reward(op, block, blockid)
    if opType == "author_reward":
        save_author_reward(op, block, blockid)
    if opType == "transfer_to_vesting":
        save_vesting_deposit(op, block, blockid)
    if opType == "fill_vesting_withdraw":
        save_vesting_withdraw(op, block, blockid)

def process_block(block, blockid):
    save_block(block, blockid)
    ops = rpc.get_ops_in_block(blockid, False)
    for tx in block['transactions']:
      for opObj in tx['operations']:
        process_op(opObj, block, blockid)
    for opObj in ops:
      process_op(opObj['op'], block, blockid)

def save_convert(op, block, blockid):
    convert = op.copy()
    _id = str(blockid) + '/' + str(op['requestid'])
    convert.update({
        '_id': _id,
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S"),
        'amount': float(convert['amount'].split()[0]),
        'type': convert['amount'].split()[1]
    })
    queue_update_account(op['owner'])
    db.convert.update({'_id': _id}, convert, upsert=True)

def save_transfer(op, block, blockid):
    transfer = op.copy()
    _id = str(blockid) + '/' + op['from'] + '/' + op['to']
    transfer.update({
        '_id': _id,
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S"),
        'amount': float(transfer['amount'].split()[0]),
        'type': transfer['amount'].split()[1]
    })
    db.transfer.update({'_id': _id}, transfer, upsert=True)
    queue_update_account(op['from'])
    if op['from'] != op['to']:
        queue_update_account(op['to'])

def save_curation_reward(op, block, blockid):
    reward = op.copy()
    _id = str(blockid) + '/' + op['curator'] + '/' + op['comment_author'] + '/' + op['comment_permlink']
    reward.update({
        '_id': _id,
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S"),
        'reward': float(reward['reward'].split()[0])
    })
    db.curation_reward.update({'_id': _id}, reward, upsert=True)
    queue_update_account(op['curator'])

def save_author_reward(op, block, blockid):
    reward = op.copy()
    # Force the comment to update one last time
    comment_id = op['author'] + '/' + op['permlink']
    update_comment(op['author'], op['permlink'])
    # Load the comment so we can update it
    comment = db.comment.find_one({'_id': comment_id})
    if comment and isinstance(comment, dict) and 'json_metadata' in comment and isinstance(comment['json_metadata'], dict) and 'app' in comment['json_metadata']:
        if not isinstance(comment['json_metadata']['app'], str):
            comment['json_metadata']['app'] = str(comment['json_metadata']['app'])
        parts = comment['json_metadata']['app'].split('/')
        if len(parts) > 1:
          reward.update({
            'app_name': parts[0],
            'app_version': parts[1]
          })
    _id = str(blockid) + '/' + op['author'] + '/' + op['permlink']
    # Update the reward
    reward.update({
        '_id': _id,
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S")
    })
    for key in ['sbd_payout', 'steem_payout', 'vesting_payout']:
        reward[key] = float(reward[key].split()[0])
    # Save the reward
    db.author_reward.update({'_id': _id}, reward, upsert=True)
    # Save the reward on the comment
    db.comment.update({
      '_id': comment_id
    }, {
      '$set': {'reward': reward}
    })
    # Queue an update for the author
    queue_update_account(op['author'])

def save_vesting_deposit(op, block, blockid):
    vesting = op.copy()
    _id = str(blockid) + '/' + op['from'] + '/' + op['to']
    vesting.update({
        '_id': _id,
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S"),
        'amount': float(vesting['amount'].split()[0])
    })
    db.vesting_deposit.update({'_id': _id}, vesting, upsert=True)
    queue_update_account(op['from'])
    if op['from'] != op['to']:
        queue_update_account(op['to'])

def save_vesting_withdraw(op, block, blockid):
    vesting = op.copy()
    _id = str(blockid) + '/' + op['from_account'] + '/' + op['to_account']
    vesting.update({
        '_id': _id,
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S")
    })
    for key in ['deposited', 'withdrawn']:
        vesting[key] = float(vesting[key].split()[0])
    db.vesting_withdraw.update({'_id': _id}, vesting, upsert=True)
    queue_update_account(op['from_account'])
    if op['from_account'] != op['to_account']:
        queue_update_account(op['to_account'])

def save_custom_json(op, block, blockid):
    try:
        data = json.loads(op['json'])
        if type(data) is list:
            if data[0] == 'reblog':
                save_reblog(data, op, block, blockid)
            if data[0] == 'follow':
                save_follow(data, op, block, blockid)
    except ValueError:
        pprint("[STEEM] - Processing failure")
        pprint(blockid)
        pprint(op['json'])

def save_feed_publish(op, block, blockid):
    doc = op.copy()
    _id = str(blockid) + '|' + doc['publisher']
    query = {
        '_id': _id
    }
    doc.update({
        '_id': _id,
        '_block': blockid,
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S"),
    })
    for key in ['base', 'quote']:
        doc['exchange_rate'][key] = float(doc['exchange_rate'][key].split()[0])

    db.feed_publish.update(query, doc, upsert=True)

def save_follow(data, op, block, blockid):
    doc = data[1].copy()
    if 'following' in doc and 'follower' in doc:
      query = {
          '_block': blockid,
          'follower': doc['follower'],
          'following': doc['following']
      }
      doc.update({
          '_block': blockid,
          '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S"),
      })
      db.follow.update(query, doc, upsert=True)
      queue_update_account(doc['follower'])
      if doc['follower'] != doc['following']:
          queue_update_account(doc['following'])

def save_benefactor_reward(op, block, blockid):
    doc = op.copy()
    query = {
        '_block': blockid,
        'benefactor': doc['benefactor'],
        'permlink': doc['permlink'],
        'author': doc['author']
    }
    doc.update({
        '_block': blockid,
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S"),
        'reward': float(doc['reward'].split()[0])
    })
    db.benefactor_reward.update(query, doc, upsert=True)

def save_reblog(data, op, block, blockid):
    if len(data) > 1:
        doc = data[1].copy()
        if all (k in doc for k in ('permlink','account')):
            query = {
                '_block': blockid,
                'permlink': doc['permlink'],
                'account': doc['account']
            }
            doc.update({
                '_block': blockid,
                '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S"),
            })
            db.reblog.update(query, doc, upsert=True)

def save_block(block, blockid):
    doc = block.copy()
    doc.update({
        '_id': blockid,
        '_ts': datetime.strptime(doc['timestamp'], "%Y-%m-%dT%H:%M:%S"),
    })
    db.block_30d.update({'_id': blockid}, doc, upsert=True)

def save_pow(op, block, blockid):
    _id = "unknown"
    if isinstance(op['work'], list):
        _id = str(blockid) + '-' + op['work'][1]['input']['worker_account']
    else:
        _id = str(blockid) + '-' + op['worker_account']
    doc = op.copy()
    doc.update({
        '_id': _id,
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S"),
        'block': blockid,
    })
    db.pow.update({'_id': _id}, doc, upsert=True)

def save_vote(op, block, blockid):
    vote = op.copy()
    _id = str(blockid) + '/' + op['voter'] + '/' + op['author'] + '/' + op['permlink']
    vote.update({
        '_id': _id,
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S")
    })
    db.vote.update({'_id': _id}, vote, upsert=True)

def save_witness_vote(op, block, blockid):
    witness_vote = op.copy()
    query = {
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S"),
        'account': witness_vote['account'],
        'witness': witness_vote['witness']
    }
    witness_vote.update({
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S")
    })
    db.witness_vote.update(query, witness_vote, upsert=True)
    queue_update_account(witness_vote['account'])
    if witness_vote['account'] != witness_vote['witness']:
        queue_update_account(witness_vote['witness'])

def update_comment(author, permlink, op=None, block=None, blockid=None):
    # Generate our unique permlink
    _id = author + '/' + permlink
    try:
      # skip this post, since xeroc managed to break processing of it :)
      if(_id == "xeroc/re-piston-20160818t080811"):
        return

      # if this is a diff, save a copy of the diff into the comment_diff collection
      if op and 'body' in op and op['body'].startswith("@@ "):
        diffid = str(blockid) + '/' + op['author'] + '/' + op['permlink']
        diff = op.copy()
        query = {'_id': diffid}
        diff.update({
          '_id': diffid,
          '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S"),
          'block': int(blockid),
        })
        db.comment_diff.update(query, diff, upsert=True)

      # get the post as it currently exists
      comment = rpc.get_content(author, permlink).copy()
      comment.update({
          '_id': _id,
      })

      # fix all values on active votes
      active_votes = []
      for vote in comment['active_votes']:
          vote['rshares'] = float(vote['rshares'])
          vote['weight'] = float(vote['weight'])
          vote['time'] = datetime.strptime(vote['time'], "%Y-%m-%dT%H:%M:%S")
          active_votes.append(vote)
      comment['active_votes'] = active_votes

      for key in ['author_reputation', 'net_rshares', 'children_abs_rshares', 'abs_rshares', 'vote_rshares']:
          comment[key] = float(comment[key])
      for key in ['total_pending_payout_value', 'pending_payout_value', 'max_accepted_payout', 'total_payout_value', 'curator_payout_value']:
          comment[key] = float(comment[key].split()[0])
      for key in ['active', 'created', 'cashout_time', 'last_payout', 'last_update', 'max_cashout_time']:
          comment[key] = datetime.strptime(comment[key], "%Y-%m-%dT%H:%M:%S")
      for key in ['json_metadata']:
          try:
            comment[key] = json.loads(comment[key])
          except ValueError:
            comment[key] = comment[key]

      comment['scanned'] = datetime.now()
      results = db.comment.update({'_id': _id}, {'$set': comment}, upsert=True)

      if comment['depth'] > 0 and not results['updatedExisting'] and comment['url'] != '':
          url = comment['url'].split('#')[0]
          parts = url.split('/')
          original_id = parts[2].replace('@', '') + '/' + parts[3]
          db.comment.update(
              {
                  '_id': original_id
              },
              {
                  '$set': {
                      'last_reply': comment['created'],
                      'last_reply_by': comment['author']
                  }
              }
          )
    except:
      pass

def update_comment_options(op, block, blockid):
    _id = op['author'] + '/' + op['permlink']
    data = {
      'options': op.copy()
    }
    db.comment.update({'_id': _id}, {'$set': data}, upsert=True)

mvest_per_account = {}

def load_accounts():
    pprint("[STEEM] - Loading all accounts")
    for account in db.account.find():
        if 'vesting_shares' in account:
            mvest_per_account.update({account['name']: account['vesting_shares']})

def queue_update_account(account_name):
    # pprint("Queue Update: " + account_name)
    db.account.update({'_id': account_name}, {'$set': {'_dirty': True}}, upsert=True)

def update_account(account_name):
    # pprint("Update Account: " + account_name)
    # Load State
    state = rpc.get_accounts([account_name])
    if not state:
      return
    # Get Account Data
    account = collections.OrderedDict(sorted(state[0].items()))
    # Get followers
    account['followers'] = []
    account['followers_count'] = 0
    account['followers_mvest'] = 0
    followers_results = rpc.get_followers(account_name, "", "blog", 100, api="follow")
    while followers_results:
      last_account = ""
      for follower in followers_results:
        last_account = follower['follower']
        if 'blog' in follower['what'] or 'posts' in follower['what']:
          account['followers'].append(follower['follower'])
          account['followers_count'] += 1
          if follower['follower'] in mvest_per_account.keys():
            account['followers_mvest'] += float(mvest_per_account[follower['follower']])
      followers_results = rpc.get_followers(account_name, last_account, "blog", 100, api="follow")[1:]
    # Get following
    account['following'] = []
    account['following_count'] = 0
    following_results = rpc.get_following(account_name, -1, "blog", 100, api="follow")
    while following_results:
      last_account = ""
      for following in following_results:
        last_account = following['following']
        if 'blog' in following['what'] or 'posts' in following['what']:
          account['following'].append(following['following'])
          account['following_count'] += 1
      following_results = rpc.get_following(account_name, last_account, "blog", 100, api="follow")[1:]
    # Convert to Numbers
    account['proxy_witness'] = float(account['proxied_vsf_votes'][0]) / 1000000
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
    if '_dirty' in account:
        del account['_dirty']
    db.account.update({'_id': account_name}, account, upsert=True)

def update_queue():
    # -- Process Queue
    queue_length = 100
    # Don't update automatically if it's older than 3 days (let it update when votes occur)
    max_date = datetime.now() + timedelta(-3)
    # Don't update if it's been scanned within the six hours
    scan_ignore = datetime.now() - timedelta(hours=6)

    # -- Process Queue - Find 100 previous comments to update
    queue = db.comment.find({
        'created': {'$gt': max_date},
        'scanned': {'$lt': scan_ignore},
    }).sort([('scanned', 1)]).limit(queue_length)
    pprint("[Queue] Comments - " + str(queue_length) + " of " + str(queue.count()))
    for item in queue:
        update_comment(item['author'], item['permlink'])

    # -- Process Queue - Find 100 comments that have past the last payout and need an update
    queue = db.comment.find({
        'cashout_time': {
          '$lt': datetime.now()
        },
        'mode': {
          '$in': ['first_payout', 'second_payout']
        },
        'depth': 0,
        'pending_payout_value': {
          '$gt': 0
        }
    }).limit(queue_length)
    pprint("[Queue] Past Payouts - " + str(queue_length) + " of " + str(queue.count()))
    for item in queue:
        update_comment(item['author'], item['permlink'])
    # -- Process Queue - Dirty Accounts
    queue_length = 20
    queue = db.account.find({
        '_dirty': True
    }).limit(queue_length)
    pprint("[Queue] Updating Accounts - " + str(queue_length) + " of " + str(queue.count()))
    for item in queue:
        update_account(item['_id'])
    pprint("[Queue] Done")

if __name__ == '__main__':
    pprint("[STEEM] - Starting SteemDB Sync Service")
    sys.stdout.flush()
    # Let's find out how often blocks are generated!
    config = rpc.get_config()
    block_interval = config["STEEM_BLOCK_INTERVAL"]
    load_accounts()
    # We are going to loop indefinitely
    while True:
        # Update the Queue
        # update_queue()
        # Process New Blocks
        props = rpc.get_dynamic_global_properties()
        block_number = props['last_irreversible_block_num']
        while (block_number - last_block) > 0:
            last_block += 1
            pprint("[STEEM] - Starting Block #" + str(last_block))
            sys.stdout.flush()
            # Get full block
            block = rpc.get_block(last_block)
            # Process block
            process_block(block, last_block)
            # Update our block height
            db.status.update({'_id': 'height'}, {"$set" : {'value': last_block}}, upsert=True)
            # if last_block % 100 == 0:
            pprint("[STEEM] - Processed up to Block #" + str(last_block))
            sys.stdout.flush()

        sys.stdout.flush()

        # Sleep for one block
        time.sleep(block_interval)
