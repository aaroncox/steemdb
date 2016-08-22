from datetime import datetime
from pymongo import MongoClient
from bson.objectid import ObjectId
from pprint import pprint
import collections
import time
import sys
import os

mongo = MongoClient("mongodb://mongo")
db = mongo.steemdb

if __name__ == '__main__':
  records = db.account_history.find({"account": {"$exists": False}})
  for record in records:
    try:
      oldid = str(record['_id'])
      s1 = oldid[0:-9]
      s2 = datetime.strptime(oldid[-8:], "%Y%m%d")
      newDocument = record.copy()
      newDocument['date'] = s2
      newDocument['account'] = s1
      del newDocument['_id']
      pprint("Adding new record for account " + newDocument['account'])
      pprint("Removing ID " + record['_id'])
      db.account_history.insert(newDocument)
      db.account_history.remove({'_id': record['_id']})
      sys.stdout.flush()
    except OSError as err:
        print("OS error: {0}".format(err))
    except ValueError:
        print("Could not convert data to an integer.")
    except:
        print("Unexpected error:", sys.exc_info()[0])
        raise
