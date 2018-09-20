<?php
namespace SteemDB\Controllers;

use MongoDB\BSON\UTCDateTime;

use SteemDB\Models\Account;
use SteemDB\Models\AuthorReward;
use SteemDB\Models\BenefactorReward;
use SteemDB\Models\Block30d;
use SteemDB\Models\Comment;
use SteemDB\Models\Convert;
use SteemDB\Models\CurationReward;
use SteemDB\Models\Status;
use SteemDB\Models\Vote;
use SteemDB\Models\VestingDeposit;
use SteemDB\Models\VestingWithdraw;

class LabsController extends ControllerBase
{
  public function indexAction()
  {

  }

  protected function calcMedian($values) {
      $count = count($values);
      $mid = floor(($count-1)/2);
      if($count % 2) {
        $median = $values[$mid];
      } else {
        $low = $values[$mid];
        $high = $values[$mid+1];
        $median = (($low+$high)/2);
      }
      return $median;
  }

  public function conversionsAction() {
    $query = array();
    $sort = array('_ts' => -1);
    $this->view->conversions = Convert::find([
      $query,
      'sort' => $sort,
      'limit' => 1000
    ]);
  }

  public function rsharesAction() {
    $this->view->date = $date = strtotime($this->request->get("date") ?: date("Y-m-d"));
    $dates = [
      '$gte' => new UTCDateTime($date * 1000),
      '$lt' => new UTCDateTime(($date + 86400) * 1000),
    ];
    $this->view->data = Comment::rsharesAllocation($dates)->toArray();
    $rshares = 0;
    $vests = [];
    foreach($this->view->data as $voter) {
      $rshares += $voter['voters']['rshares'];
      $vests[] = $voter['account'][0]['vesting_shares'];
    }
    $this->view->median = $this->calcMedian($vests);
    $this->view->rshares = $rshares;
  }

  public function powerdownAction() {
    $props = $this->steemd->getProps();
    $converted = array(
      'current' => (float) explode(" ", $props['current_supply'])[0],
      'vesting' => (float) explode(" ", $props['total_vesting_fund_steem'])[0],
    );
    $converted['liquid'] = $converted['current'] - $converted['vesting'];
    $this->view->props = $converted;
    $this->view->dow = array('', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
    $transactions = Account::agg([
      [
        '$match' => [
          'next_vesting_withdrawal' => [
            '$gte' => new UTCDateTime(strtotime(date("Y-m-d")) * 1000)
          ],
          'vesting_withdraw_rate' => ['$gt' => 0]
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$next_vesting_withdrawal'],
            'year' => ['$year' => '$next_vesting_withdrawal'],
            'month' => ['$month' => '$next_vesting_withdrawal'],
            'day' => ['$dayOfMonth' => '$next_vesting_withdrawal'],
            'dow' => ['$dayOfWeek' => '$next_vesting_withdrawal'],
          ],
          'count' => ['$sum' => 1],
          'withdrawn' => ['$sum' => '$vesting_withdraw_rate'],
        ],
      ],
      [
        '$sort' => [
          '_id.year' => 1,
          '_id.doy' => 1
        ]
      ],
      [
        '$limit' => 7
      ]
    ])->toArray();
    $this->view->upcoming_total = array_sum(array_column($transactions, 'withdrawn'));
    $this->view->upcoming = $transactions;
    $transactions = VestingWithdraw::agg([
      [
        '$match' => [
          '_ts' => [
            '$gte' => new UTCDateTime((strtotime(date("Y-m-d")) - (86400 * 7)) * 1000),
          ],
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$_ts'],
            'year' => ['$year' => '$_ts'],
            'month' => ['$month' => '$_ts'],
            'day' => ['$dayOfMonth' => '$_ts'],
            'dow' => ['$dayOfWeek' => '$_ts'],
          ],
          'count' => ['$sum' => 1],
          'withdrawn' => ['$sum' => '$withdrawn'],
          'deposited' => ['$sum' => '$deposited'],
        ],
      ],
      [
        '$sort' => [
          '_id.year' => 1,
          '_id.doy' => 1
        ]
      ],
      [
        '$limit' => 8
      ]
    ])->toArray();
    $this->view->previous_total = array_sum(array_column($transactions, 'withdrawn'));
    $this->view->previous = $transactions;

    $transactions = VestingWithdraw::agg([
      [
        '$match' => [
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-30 days") * 1000),
            '$lte' => new UTCDateTime(strtotime("midnight") * 1000),
          ],
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'user' => '$from_account',
          ],
          'count' => ['$sum' => 1],
          'withdrawn' => ['$sum' => '$withdrawn'],
          'deposited' => ['$sum' => '$deposited'],
          'deposited_to' => ['$addToSet' => '$to_account'],
        ],
      ],
      [
        '$lookup' => [
          'from' => 'account',
          'localField' => '_id.user',
          'foreignField' => 'name',
          'as' => 'account'
        ]
      ],
      [
        '$sort' => [
          'withdrawn' => -1
        ]
      ],
      [
        '$limit' => 100
      ]
    ])->toArray();
    $this->view->powerdowns = $transactions;
  }

  public function flagsAction() {
    $accounts = Vote::aggregate([
      ['$match' => [
        'weight' => ['$lt' => 0]
      ]],
      ['$group' => [
        '_id' => '$author',
        'count' => ['$sum' => 1],
        'flaggers' => ['$push' => '$voter'],
        'posts' => ['$addToSet' => '$permlink']
      ]],
      ['$sort' => ['count' => -1]],
      ['$limit' => 200]
    ])->toArray();
    foreach($accounts as $idx => $account) {
      $voters = array_count_values((array)$account['flaggers']);
      arsort($voters);
      $accounts[$idx]['voters'] = array_slice($voters, 0, 10);
    }
    $this->view->accounts = $accounts;
  }

  public function powerupAction() {
    // {transactions: {$elemMatch: {'operations.0.0': 'transfer_to_vesting'}}
    $days = 30;
    $this->view->filter = $filter = $this->request->get('filter');
    switch($filter) {
      case "week":
        $days = 7;
        break;
      case "day":
        $days = 1;
        break;
    }
    $powerups = VestingDeposit::agg([
      [
        '$match' => [
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-".$days." days") * 1000),
          ],
        ]
      ],
      [
        '$project' => [
          'date' => [
            'doy' => ['$dayOfYear' => '$_ts'],
            'year' => ['$year' => '$_ts'],
            'month' => ['$month' => '$_ts'],
            'day' => ['$dayOfMonth' => '$_ts'],
          ],
          'to' => '$to',
          'amount' => '$amount',
          'from' => '$from',
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'user' => [ '$cond' => [
              'if' => ['$eq' => ['$to', '']],
              'then' => '$from',
              'else' => '$to',
            ] ]
          ],
          'count' => ['$sum' => 1],
          'instances' => ['$addToSet' => '$amount']
        ],
      ],
      [
        '$limit' => 1000
      ],
      [
        '$lookup' => [
          'from' => 'account',
          'localField' => '_id.user',
          'foreignField' => 'name',
          'as' => 'account'
        ]
      ],
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();
    // var_dump($powerups); exit;
    foreach($powerups as $idx => $tx) {
      $powerups[$idx]['total'] = 0;
      foreach($tx['instances'] as $powerup) {
        $powerups[$idx]['total'] += (float) explode(" ", $powerup)[0];
      }
    }
    usort($powerups, function($a, $b) {
      return $b['total'] - $a['total'];
    });
    $this->view->powerups = $powerups;
  }
  public function photochallengeAction() {
    $query = array(
      'depth' => 0,
      'json_metadata.tags' => 'steemitphotochallenge'
    );
    $sort = array('created' => -1);
    $posts = Comment::find(array(
      $query,
      'sort' => $sort,
      'limit' => 5000
    ));
    header('Content-type: text/csv');
    header('Content-Disposition: attachment; filename="posts.csv"');
    $file = fopen('php://output', 'w');
    foreach($posts as $post) {
      fputcsv($file, [
        $post->created->toDateTime()->format("Y-m-d H:i:s"),
        $post->author,
        $post->permlink,
      ]);
    }
  }
  public function votefocusingAction() {
    $this->view->focus = Vote::agg([
      [
        '$match' => [
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-7 days") * 1000),
            '$lte' => new UTCDateTime(strtotime("midnight") * 1000),
          ],
          'weight' => [
            '$gt' => 500
          ]
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'permlink' => '$permlink',
            'voter' => '$voter',
            'author' => '$author'
          ],
          'weight' => ['$avg' => '$weight']
        ]
      ],
      [
        '$project' => [
          '_id' => true,
          'weight' => true,
          'voterisauthor' => ['$eq' => ['$_id.voter', '$_id.author']],
        ]
      ],
      [
        '$match' => [
          'voterisauthor' => false
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'voter' => '$_id.voter',
            'author' => '$_id.author'
          ],
          'count' => ['$sum' => 1],
          'weight' => ['$avg' => '$weight'],
        ]
      ],
      [
        '$sort' => [
          'count' => -1
        ]
      ],
      [
        '$limit' => 200
      ],
      [
        '$lookup' => [
          'from' => 'account',
          'localField' => '_id.voter',
          'foreignField' => 'name',
          'as' => 'account'
        ]
      ],
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();
  }

  public function curationAction() {
    $this->view->date = $date = strtotime($this->request->get('date') ?: date('Y-m-d'));
    $this->view->grouping = $grouping = $this->request->get('grouping', 'string');
    switch($grouping) {
      case "monthly":
        $this->view->date = $date = strtotime($this->request->get('date') ?: date('Y-m'));
        $month = new \DateTime();
        $month->setTimestamp($date);
        $dates = [
          '$gte' => new UTCDateTime($month),
          '$lt' => new UTCDateTime($month->modify('first day of next month')),
        ];
        break;
      default:
        $dates = [
          '$gte' => new UTCDateTime($date * 1000),
          '$lt' => new UTCDateTime(($date + 86400) * 1000),
        ];
        break;
    }
    $this->view->leaderboard = CurationReward::agg([
      [
        '$match' => [
          '_ts' => $dates
        ]
      ],
      [
        '$group' => [
          '_id' => '$curator',
          'count' => ['$sum' => 1],
          'total' => ['$sum' => '$reward'],
          'authors' => ['$addToSet' => '$comment_author'],
          'permlinks' => ['$addToSet' => [
            '$concat' => ['$comment_author','/','$comment_permlink']
          ]]
        ]
      ],
      [
        '$sort' => [
          'total' => -1
        ]
      ],
      [
        '$limit' => 100
      ],
      [
        '$lookup' => [
          'from' => 'account',
          'localField' => '_id',
          'foreignField' => 'name',
          'as' => 'account'
        ]
      ],
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();
    // var_dump($this->view->leaderboard); exit;
  }

  public function authorAction() {
    $this->view->date = $date = strtotime(($this->request->get("date") ?: date("Y-m-d")));
    $this->view->grouping = $grouping = $this->request->get('grouping', 'string');
    switch($grouping) {
      case "monthly":
        $this->view->date = $date = strtotime($this->request->get('date') ?: date('Y-m'));
        $month = new \DateTime();
        $month->setTimestamp($date);
        $dates = [
          '$gte' => new UTCDateTime($month),
          '$lt' => new UTCDateTime($month->modify('first day of next month')),
        ];
        break;
      default:
        $dates = [
          '$gte' => new UTCDateTime($date * 1000),
          '$lt' => new UTCDateTime(($date + 86400) * 1000),
        ];
        break;
    }
    $leaderboard = AuthorReward::agg([
      [
        '$match' => [
          '_ts' => $dates
        ]
      ],
      ['$project' => [
        'prefix' => ['$substr' => ['$permlink', 0, 3]],
        'author' => '$author',
        'permlink' => '$permlink',
        'steem_payout' => '$steem_payout',
        'vesting_payout' => '$vesting_payout',
        'sbd_payout' => '$sbd_payout',
      ]],
      [
        '$group' => [
          '_id' => '$author',
          'count' => ['$sum' => 1],
          'posts' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$prefix', 're-']],
              0,
              1,
            ]],
          ],
          'replies' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$prefix', 're-']],
              1,
              0,
            ]],
          ],
          'postVest' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$prefix', 're-']],
              0,
              '$vesting_payout',
            ]],
          ],
          'postSbd' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$prefix', 're-']],
              0,
              '$sbd_payout',
            ]],
          ],
          'postSteem' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$prefix', 're-']],
              0,
              '$steem_payout',
            ]],
          ],
          'replyVest' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$prefix', 're-']],
              '$vesting_payout',
              0,
            ]],
          ],
          'replySbd' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$prefix', 're-']],
              '$sbd_payout',
              0,
            ]],
          ],
          'replySteem' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$prefix', 're-']],
              '$steem_payout',
              0,
            ]],
          ],
          'sbd' => ['$sum' => '$sbd_payout'],
          'steem' => ['$sum' => '$steem_payout'],
          'vest' => ['$sum' => '$vesting_payout'],
          'permlinks' => ['$addToSet' => [
            '$concat' => ['$author','/','$permlink']
          ]]
        ]
      ],
      [
        '$sort' => [
          'vest' => -1
        ]
      ],
    ],[
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();
    // var_dump($leaderboard); exit;
    $totals = array(
      'sbd' => 0,
      'steem' => 0,
      'sp' => 0,
      'vest' => 0,
    );
    foreach($leaderboard as $idx => $data) {
      $totals['sbd'] += $data['sbd'];
      $totals['steem'] += $data['steem'];
      $totals['sp'] += (float) $this->convert->vest2sp($data['vest'], false);
      $totals['vest'] += $data['vest'];
      $totals['postVest'] += $data['postVest'];
    }
    $this->view->leaderboard = $leaderboard;
    $this->view->totals = $totals;
  }

  public function clientsAction() {
    // $rewards = AuthorReward::agg([
    //   ['$sort' => [
    //     '_ts' => -1
    //   ]],
    //   ['$group' => [
    //     '_id' => [
    //       'app' => '$app_name',
    //       'doy' => ['$dayOfYear' => '$_ts'],
    //       'year' => ['$year' => '$_ts'],
    //       'month' => ['$month' => '$_ts'],
    //       'day' => ['$dayOfMonth' => '$_ts'],
    //       'dow' => ['$dayOfWeek' => '$_ts'],
    //     ],
    //     'sbd_payout' => ['$sum' => '$sbd_payout'],
    //     'vesting_payout' => ['$sum' => '$vesting_payout'],
    //     'steem_payout' => ['$sum' => '$steem_payout'],
    //     'value' => [
    //       '$sum' => ['$cond' => [
    //         ['$and' => [
    //           ['$eq' => ['$sbd_payout', 0]],
    //           ['$eq' => ['$steem_payout', 0]],
    //         ]],
    //         '$vesting_payout',
    //         ['$multiply' => ['$vesting_payout', 2]],
    //       ]],
    //     ],
    //     // 'value' => [ '$cond' => [
    //     //   'if' => ,
    //     //   'then' => ,
    //     //   'else' => ,
    //     // ]]
    //   ]],
    //   ['$sort' => [
    //     '_id.year' => 1,
    //     '_id.doy' => 1,
    //     'value' => -1
    //   ]],
    //   ['$limit' => 10]
    // ])->toArray();
    // var_dump($rewards); exit;
    $results = Status::findFirst([['_id' => 'clients-snapshot']]);
    $this->view->dates = $results->data;
    $posts = [];
    $rewards = [];
    foreach($results->data as $date) {
      foreach($date->clients as $client) {
        if(!isset($rewards[$client->client])) $rewards[$client->client] = 0;
        if(!isset($posts[$client->client])) $posts[$client->client] = 0;
        $posts[$client->client] += $client->count;
        $rewards[$client->client] += $client->reward;
      }
    }
    arsort($posts);
    arsort($rewards);
    $this->view->posts = $posts;
    $this->view->rewards = $rewards;
  }

  public function benefactorsAction() {
    $rewards = BenefactorReward::agg([
      ['$sort' => [
        '_ts' => -1
      ]],
      ['$group' => [
        '_id' => [
          'benefactor' => '$benefactor',
          'doy' => ['$dayOfYear' => '$_ts'],
          'year' => ['$year' => '$_ts'],
          'month' => ['$month' => '$_ts'],
          'day' => ['$dayOfMonth' => '$_ts'],
          'dow' => ['$dayOfWeek' => '$_ts'],
        ],
        'reward' => ['$sum' => '$reward'],
        'count' => ['$sum' => 1]
      ]],
      ['$group' => [
        '_id' => [
          'doy' => '$_id.doy',
          'year' => '$_id.year',
          'month' => '$_id.month',
          'day' => '$_id.day',
          'dow' => '$_id.dow',
        ],
        'benefactors' => [
          '$push' => [
            'benefactor' => '$_id.benefactor',
            'count' => '$count',
            'reward' => '$reward'
          ]
        ],
        'reward'  => [
          '$sum' => '$reward'
        ],
        'total' => [
          '$sum' => '$count'
        ]
      ]],
      ['$sort' => [
        '_id.year' => 1,
        '_id.doy' => 1,
        'reward' => -1
      ]],
      ['$limit' => 10]
    ])->toArray();
    // var_dump($rewards[0]); exit;
    $this->view->dates = $rewards;
  }

  public function pendingAction() {
    $query = [
      'created' => [
        '$gte' => new UTCDateTime(strtotime("-7 days") * 1000),
        '$lte' => new UTCDateTime(strtotime("-156 hours") * 1000),
      ]
    ];
    $sort = [
      'pending_payout_value' => -1
    ];
    $results = Comment::find([
      $query,
      "sort" => $sort,
      "limit" => 200
    ]);
    $this->view->comments = $results;
  }

  public function hf19Action() {
    $cacheKey = 'hf19';
    $cached = $this->memcached->get($cacheKey);
    if($cached === null) {
      $results = Vote::agg([
        [
          '$match' => [
            '_ts' => [
              '$gte' => new UTCDateTime(strtotime("-30 days") * 1000),
              '$lte' => new UTCDateTime(strtotime("midnight") * 1000),
            ],
          ]
        ],
        [
          '$group' => [
            '_id' => [
              'doy' => ['$dayOfYear' => '$_ts'],
              'year' => ['$year' => '$_ts'],
              'month' => ['$month' => '$_ts'],
              'day' => ['$dayOfMonth' => '$_ts'],
              'dow' => ['$dayOfWeek' => '$_ts'],
            ],
            'count' => ['$sum' => 1],
            'weight' => [ '$avg' => '$weight' ],
            'self' => ['$sum' =>[ '$cond' => [
              'if' => ['$eq' => ['$author', '$voter']],
              'then' => 1,
              'else' => 0,
            ] ] ],
            'self_weight' => ['$avg' =>[ '$cond' => [
              'if' => ['$eq' => ['$author', '$voter']],
              'then' => '$weight',
              'else' => null,
            ] ] ],
          ],
        ],
        [
          '$sort' => [
            '_id.year' => 1,
            '_id.doy' => 1
          ]
        ],
      ], [
        'allowDiskUse' => true,
        'cursor' => [
          'batchSize' => 0
        ]
      ])->toArray();
      $this->memcached->save($cacheKey, $results, 86400);
      $this->view->results = $results;
    } else {
      // Use cache
      $this->view->results = $cached;
    }

  }

}
