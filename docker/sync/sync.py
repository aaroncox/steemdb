from datetime import datetime, timedelta
from steemapi.steemnoderpc import SteemNodeRPC
from piston.steem import Post
from pymongo import MongoClient
from pprint import pprint
import json
import time
import sys
import os

rpc = SteemNodeRPC("ws://" + os.environ['steemnode'], "", "")
mongo = MongoClient("mongodb://mongo")
db = mongo.golosdb

init = db.status.find_one({'_id': 'height'})
if(init):
  last_block = init['value']
else:
  last_block = 0

# ------------
# For development:
#
# If you're looking for a faster way to sync the data and get started,
# uncomment this line with a more recent block, and the chain will start
# to sync from that point onwards. Great for a development environment
# where you want some data but don't want to sync the entire blockchain.
# ------------

# last_block = 5298239

def process_op(opObj, block, blockid):
    opType = opObj[0]
    op = opObj[1]
    if opType == "comment":
        # Update the comment
        update_comment(op['author'], op['permlink'])
    if opType == "vote":
        # Update the comment and vote
        update_comment(op['author'], op['permlink'])
        save_vote(op, block, blockid)
    if opType == "custom_json":
        save_custom_json(op, block, blockid)
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
    # ops = rpc.get_ops_in_block(blockid, False)
    for tx in block['transactions']:
      for opObj in tx['operations']:
        process_op(opObj, block, blockid)
    # for opObj in ops:
    #   process_op(opObj['op'], block, blockid)

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

def save_curation_reward(op, block, blockid):
    reward = op.copy()
    _id = str(blockid) + '/' + op['curator'] + '/' + op['comment_author'] + '/' + op['comment_permlink']
    reward.update({
        '_id': _id,
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S"),
        'reward': float(reward['reward'].split()[0])
    })

    db.curation_reward.update({'_id': _id}, reward, upsert=True)

def save_author_reward(op, block, blockid):
    reward = op.copy()
    _id = str(blockid) + '/' + op['author'] + '/' + op['permlink']
    reward.update({
        '_id': _id,
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S")
    })
    for key in ['sbd_payout', 'steem_payout', 'vesting_payout']:
        reward[key] = float(reward[key].split()[0])

    db.author_reward.update({'_id': _id}, reward, upsert=True)

def save_vesting_deposit(op, block, blockid):
    vesting = op.copy()
    _id = str(blockid) + '/' + op['from'] + '/' + op['to']
    vesting.update({
        '_id': _id,
        '_ts': datetime.strptime(block['timestamp'], "%Y-%m-%dT%H:%M:%S"),
        'amount': float(vesting['amount'].split()[0])
    })

    db.vesting_deposit.update({'_id': _id}, vesting, upsert=True)

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

def save_custom_json(op, block, blockid):
    try:
        data = json.loads(op['json'])
        if type(data) is list:
            if data[0] == 'reblog':
                save_reblog(data, op, block, blockid)
            if data[0] == 'follow':
                save_follow(data, op, block, blockid)
    except ValueError:
        pprint("Processing failure")
        pprint(blockid)
        pprint(op['json'])

def save_follow(data, op, block, blockid):
    doc = data[1].copy()
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

def save_reblog(data, op, block, blockid):
    doc = data[1].copy()
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
    db.block.update({'_id': blockid}, doc, upsert=True)
    db.block_30d.update({'_id': blockid}, doc, upsert=True)

def save_pow(op, block, blockid):
    _id = str(blockid) + '-' + op['work'][1]['input']['worker_account']
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

def update_comment(author, permlink):
    _id = author + '/' + permlink
    if(_id == "xeroc/re-piston-20160818t080811"):
      return
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

    for key in ['author_reputation', 'net_rshares', 'children_abs_rshares', 'abs_rshares', 'children_rshares2', 'vote_rshares']:
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
    db.comment.update({'_id': _id}, comment, upsert=True)

if __name__ == '__main__':
    # Let's find out how often blocks are generated!
    config = rpc.get_config()
    block_interval = config["GOLOSIT_BLOCK_INTERVAL"]

    # We are going to loop indefinitely
    while True:

        # -- Process Queue
        queue_length = 100
        # Don't update automatically if it's older than 3 days (let it update when votes occur)
        max_date = datetime.now() + timedelta(-3)
        # Don't update if it's been scanned within the six hours
        scan_ignore = datetime.now() - timedelta(hours=6)

        # Find 100 previous comments to update
        queue = db.comment.find({
            'created': {'$gt': max_date},
            'scanned': {'$lt': scan_ignore},
        }).sort([('scanned', 1)]).limit(queue_length)
        pprint("Processing Queue - " + str(queue_length) + " of " + str(queue.count()))
        for item in queue:
            update_comment(item['author'], item['permlink'])

        # Find 100 comments that have past the last payout and need an update
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
        pprint("Processing Payout Queue - " + str(queue_length) + " of " + str(queue.count()))
        for item in queue:
            update_comment(item['author'], item['permlink'])

        # Process New Blocks
        props = rpc.get_dynamic_global_properties()
        block_number = props['last_irreversible_block_num']
        while (block_number - last_block) > 0:
            last_block += 1
            # Get full block
            block = rpc.get_block(last_block)
            # Process block
            process_block(block, last_block)
            # Update our block height
            db.status.update({'_id': 'height'}, {"$set" : {'value': last_block}}, upsert=True)
            # if last_block % 100 == 0:
            pprint("Processed up to Block #" + str(last_block))

        sys.stdout.flush()

        # Sleep for one block
        time.sleep(block_interval)
