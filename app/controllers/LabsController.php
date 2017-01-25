<?php
namespace SteemDB\Controllers;

use SteemDB\Models\Account;
use SteemDB\Models\AuthorReward;
use SteemDB\Models\Block30d;
use SteemDB\Models\Comment;
use SteemDB\Models\CurationReward;
use SteemDB\Models\Vote;
use SteemDB\Models\VestingWithdraw;
use MongoDB\BSON\UTCDateTime;

class LabsController extends ControllerBase
{
  public function indexAction()
  {

  }
  public function rsharesAction() {
    $this->view->date = $date = strtotime($this->request->get("date") ?: date("Y-m-d"));
    $dates = [
      '$gte' => new UTCDateTime($date * 1000),
      '$lt' => new UTCDateTime(($date + 86400) * 1000),
    ];
    $this->view->data = Comment::rsharesAllocation($dates)->toArray();
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
    $transactions = Block30d::agg([
      [
        '$match' => [
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-".$days." days") * 1000),
          ],
          'transactions' => [
            '$elemMatch' => ['operations.0.0' => 'transfer_to_vesting']
          ]
        ]
      ],
      [
        '$unwind' => '$transactions'
      ],
      [
        '$unwind' => '$transactions.operations',
      ],
      [
        '$match' => [
          'transactions.operations.0' => 'transfer_to_vesting'
        ]
      ],
      [
        '$unwind' => '$transactions.operations',
      ],
      [
        '$match' => [
          'transactions.operations.to' => ['$exists' => true]
        ]
      ],
      [
        '$project' => [
          'target' => '$transactions.operations',
          'date' => [
            'doy' => ['$dayOfYear' => '$_ts'],
            'year' => ['$year' => '$_ts'],
            'month' => ['$month' => '$_ts'],
            'day' => ['$dayOfMonth' => '$_ts'],
          ],
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'user' => '$target.to',
          ],
          'count' => ['$sum' => 1],
          'instances' => ['$addToSet' => '$target.amount']
        ],
      ],
      [
        '$lookup' => [
          'from' => 'account',
          'localField' => '_id.user',
          'foreignField' => 'name',
          'as' => 'account'
        ]
      ]
    ])->toArray();
    foreach($transactions as $idx => $tx) {
      $transactions[$idx]['total'] = 0;
      foreach($tx['instances'] as $powerup) {
        $transactions[$idx]['total'] += (float) explode(" ", $powerup)[0];
      }
    }
    usort($transactions, function($a, $b) {
      return $b['total'] - $a['total'];
    });
    $this->view->powerups = $transactions;
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
            '$gte' => new UTCDateTime(strtotime("-30 days") * 1000),
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
    $this->view->date = $date = strtotime($this->request->get("date") ?: date("Y-m-d"));
    $dates = [
      '$gte' => new UTCDateTime($date * 1000),
      '$lt' => new UTCDateTime(($date + 86400) * 1000),
    ];
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
      ]
    ])->toArray();
  }

  public function authorAction() {
    $this->view->date = $date = strtotime($this->request->get("date") ?: date("Y-m-d"));
    $dates = [
      '$gte' => new UTCDateTime($date * 1000),
      '$lt' => new UTCDateTime(($date + 86400) * 1000),
    ];
    $this->view->leaderboard = AuthorReward::agg([
      [
        '$match' => [
          '_ts' => $dates
        ]
      ],
      [
        '$group' => [
          '_id' => '$author',
          'count' => ['$sum' => 1],
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
      [
        '$limit' => 100
      ]
    ])->toArray();
  }
}
