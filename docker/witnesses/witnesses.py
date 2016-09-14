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

def update_witnesses():
    now = datetime.now().date()

    pprint("SteemDB - Update Miner Queue")
    miners = rpc.get_miner_queue()
    db.statistics.update({
      '_id': 'miner_queue'
    }, {
      'key': 'miner_queue',
      'updated': datetime.combine(now, datetime.min.time()),
      'value': miners
    }, upsert=True)

    users = rpc.get_witnesses_by_vote('', 100)
    pprint("SteemDB - Update Witnesses (" + str(len(users)) + " accounts)")
    db.witness.remove({})
    for user in users:
        # Convert to Numbers
        for key in ['virtual_last_update', 'virtual_position', 'virtual_scheduled_time', 'votes']:
            user[key] = float(user[key])
        # Convert to Date
        for key in ['last_sbd_exchange_update']:
            user[key] = datetime.strptime(user[key], "%Y-%m-%dT%H:%M:%S")
        # Save current state of account
        db.witness.update({'_id': user['owner']}, user, upsert=True)
        # Create our Snapshot dict
        snapshot = user.copy()
        _id = user['owner'] + '|' + now.strftime('%Y%m%d')
        snapshot.update({
          '_id': _id
        })
        # Save Snapshot in Database
        db.witness_history.update({'_id': _id}, snapshot, upsert=True)

if __name__ == '__main__':
    # Start job immediately
    update_witnesses()
    # Schedule it to run every 5 minutes
    scheduler = BackgroundScheduler()
    scheduler.add_job(update_witnesses, 'interval', minutes=1, id='update_witnesses')
    scheduler.start()
    # Loop
    try:
        while True:
            time.sleep(2)
    except (KeyboardInterrupt, SystemExit):
        scheduler.shutdown()
