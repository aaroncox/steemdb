
db.createCollection("block_30d", {capped: true, max: 864000, size: 2147483648})


db.comment.createIndex({parent_permlink: 1})
db.comment.createIndex({scanned: 1, created: 1});
db.comment.createIndex({depth: 1, created: 1});
db.comment.createIndex({author: 1, depth: 1, created: 1});
db.comment.createIndex({pending_payout_value: 1, mode: 1, cashout_time: 1, depth: 1})

db.comment.createIndex({
  pending_payout_value: 1,
  cashout_time: 1
}, {sparse: true});

db.block.createIndex({witness: 1, _ts: 1})
db.block_30d.createIndex({witness: 1, _ts: 1})

db.vote.createIndex({voter: 1, author: 1, _ts: 1});
db.vote.createIndex({voter: 1, _ts: 1});

db.account.createIndex({name: 1});
db.account.createIndex({created: 1});
db.account.createIndex({vesting_shares: 1});
db.account.createIndex({reputation: 1});
db.account.createIndex({post_count: 1});
db.account.createIndex({followers: 1});
db.account.createIndex({witness_votes: 1});
db.account.createIndex({name: 1, vesting_shares: 1});

db.account_history.createIndex({date: 1, name: 1});


db.follow.createIndex({follower: 1, following: 1, _block: 1});

db.comment.createIndex({depth: 1, category: 1, last_reply: 1}, {sparse: true});

db.curation_reward.createIndex({curator: 1})
db.curation_reward.createIndex({_ts: 1}, {background: true})
db.comment_diff.createIndex({author: 1, permlink: 1})
db.vote.createIndex({_ts: 1, weight: 1}, {background: true});
