# Comment Indexes:
db.comment.createIndex({parent_permlink: 1})
db.comment.createIndex({scanned: 1, created: 1});
db.comment.createIndex({depth: 1, created: 1});
db.comment.createIndex({author: 1, depth: 1, created: 1});

# Comment index for sync service to find posts with a pending payout
#   and being past their cashout time
db.comment.createIndex({
  pending_payout_value: 1,
  cashout_time: 1
}, {sparse: true});

# Block Indexes:
db.block.createIndex({witness: 1, _ts: 1})

# Voter Indexes:
db.vote.createIndex({voter: 1, author: 1, _ts: 1});
db.vote.createIndex({voter: 1, _ts: 1});

# Account Indexes:
db.account.createIndex({name: 1});
db.account.createIndex({created: 1});
db.account.createIndex({vesting_shares: 1});
db.account.createIndex({reputation: 1});
db.account.createIndex({post_count: 1});
db.account.createIndex({followers: 1});
db.account.createIndex({witness_votes: 1});

# Account History Indexes:
db.account_history.createIndex({date: 1, name: 1});


