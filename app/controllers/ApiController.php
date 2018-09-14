<?php
namespace BexNetwork\Controllers;

use MongoDB\BSON\Regex;
use MongoDB\BSON\UTCDateTime;

use BexNetwork\Models\Account;
use BexNetwork\Models\AuthorReward;
use BexNetwork\Models\Block;
use BexNetwork\Models\Block30d;
use BexNetwork\Models\Comment;
use BexNetwork\Models\CurationReward;
use BexNetwork\Models\Statistics;
use BexNetwork\Models\Vote;
use BexNetwork\Models\AccountHistory;
use BexNetwork\Models\PropsHistory;
use BexNetwork\Models\Witness;
use MongoDB\BSON\ObjectID;

class ApiController extends ControllerBase
{

  public function initialize()
  {
    header('Content-type:application/json');
    $this->view->disable();
    ini_set('precision', 20);
  }

  public function voteAction()
  {
    $pipeline = [
      [
        '$match' => [
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-45 days") * 1000),
            '$lte' => new UTCDateTime(strtotime("midnight") * 1000),
          ]
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$_ts'],
            'year' => ['$year' => '$_ts'],
            'month' => ['$month' => '$_ts'],
            'week' => ['$week' => '$_ts'],
            'day' => ['$dayOfMonth' => '$_ts']
          ],
          'count' => [
            '$sum' => 1
          ]
        ]
      ],
      [
        '$sort' => [
          '_id.year' => 1,
          '_id.doy' => 1
        ]
      ]
    ];
    $data = Vote::agg($pipeline)->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function votersAction()
  {
    $pipeline = [
      [
        '$match' => [
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-45 days") * 1000),
            '$lte' => new UTCDateTime(strtotime("midnight") * 1000),
          ]
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'voter' => '$voter',
            'doy' => ['$dayOfYear' => '$_ts'],
            'year' => ['$year' => '$_ts'],
            'month' => ['$month' => '$_ts'],
            'week' => ['$week' => '$_ts'],
            'day' => ['$dayOfMonth' => '$_ts']
          ]
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => '$_id.doy',
            'year' => '$_id.year',
            'month' => '$_id.month',
            'week' => '$_id.week',
            'day' => '$_id.day',
          ],
          'count' => [
            '$sum' => 1
          ]
        ]
      ],
      [
        '$sort' => [
          '_id.year' => 1,
          '_id.doy' => 1
        ]
      ]
    ];
    $data = Vote::agg($pipeline)->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function activityAction()
  {
    $data = Comment::agg([
      [
        '$match' => [
          'created' => [
            '$gte' => new UTCDateTime(strtotime("-90 days") * 1000),
            '$lte' => new UTCDateTime(strtotime("midnight") * 1000),
          ],
          'depth' => 0,
        ]
      ],
      [
        '$project' => [
          '_id' => '$_id',
          'created' => '$created',
          'net_votes' => '$net_votes',
          'total_payout_value' => '$total_payout_value'
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$created'],
            'year' => ['$year' => '$created'],
            'month' => ['$month' => '$created'],
            'week' => ['$week' => '$created'],
            'day' => ['$dayOfMonth' => '$created']
          ],
          'posts' => [
            '$sum' => 1
          ],
          'votes' => [
            '$sum' => '$net_votes'
          ],
          'total' => [
            '$sum' => '$total_payout_value'
          ],
          'avg' => [
            '$avg' => '$total_payout_value'
          ],
          'max' => [
            '$max' => '$total_payout_value'
          ]
        ]
      ],
      [
        '$sort' => [
          '_id.year' => 1,
          '_id.doy' => 1
        ]
      ],
    ])->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function growthAction()
  {
    $users = Statistics::find([
      [
        'key' => 'users',
        'date' => ['$gt' => new UTCDateTime(strtotime("-90 days") * 1000)],
      ],
    ]);
    $data = Comment::agg([
      [
        '$match' => [
          'created' => [
            '$gte' => new UTCDateTime(strtotime("-90 days") * 1000),
            '$lte' => new UTCDateTime(strtotime("midnight") * 1000),
          ],
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$created'],
            'year' => ['$year' => '$created'],
            'month' => ['$month' => '$created'],
            'day' => ['$dayOfMonth' => '$created'],
          ],
          'authors' => [
            '$addToSet' => '$author'
          ],
          'votes' => [
            '$avg' => '$net_votes'
          ],
          'replies' => [
            '$avg' => '$children'
          ],
          'posts' => [
            '$sum' => 1
          ]
        ]
      ],
      [
        '$project' => [
          '_id' => '$_id',
          'authors' => [
            '$size' => '$authors'
          ],
          'votes' => '$votes',
          'replies' => '$replies',
          'posts' => '$posts',
        ]
      ],
      [
        '$sort' => [
          '_id.year' => 1,
          '_id.doy' => 1
        ]
      ],
      // [
      //   '$limit' => 10
      // ]
    ])->toArray();
    $gpd = array();
    foreach($users as $day) {
      $gpd[$day->date->toDateTime()->format('U')] = $day->value;
    }
    foreach($data as $key => $value) {
      $timestamp = strtotime($value->_id['year'] . "-" . $value->_id['month'] ."-". $value->_id['day']);
      if($gpd[$timestamp]) {
        $data[$key]['users'] = $gpd[$timestamp];
      } else {
        $data[$key]['users'] = 0;
      }
    }
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function newbiesAction()
  {
    $data = AccountHistory::agg([
      [
        '$match' => [
          'date' => [
            '$gte' => new UTCDateTime(strtotime("midnight") * 1000),
          ]
        ]
      ],
      [
        '$group' => [
          '_id' => '$account',
          'dates' => [
            '$push' => [
              '$dateToString' => [
                'format' => '%Y-%m-%d',
                'date' => '$date'
              ]
            ]
          ],
          'days' => [
            '$sum' => 1
          ]
        ],
      ],
      [
        '$match' => [
          'days' => 1
        ]
      ],
      [
        '$limit' => 10
      ],
    ])->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function supplyAction()
  {
    $data = AccountHistory::agg([
      [
        '$match' => [
          'date' => [
            '$gte' => new UTCDateTime(strtotime("-30 days") * 1000),
            '$lte' => new UTCDateTime(strtotime("midnight") * 1000),
          ]
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$date'],
            'year' => ['$year' => '$date'],
            'month' => ['$month' => '$date'],
            'day' => ['$dayOfMonth' => '$date'],
          ],
          'bbd' => [
            '$sum' => '$bbd_balance'
          ],
          'bbd_savings' => [
            '$sum' => '$savings_bbd_balance'
          ],
          'dpay' => [
            '$sum' => '$balance'
          ],
          'dpay_savings' => [
            '$sum' => '$savings_balance'
          ],
          'vests' => [
            '$sum' => '$vesting_shares'
          ]
        ],
      ],
      [
        '$sort' => [
          '_id.year' => 1,
          '_id.doy' => 1
        ]
      ],
      [
        '$limit' => 30
      ],
    ])->toArray();
    foreach($data as $idx => $date) {
      $data[$idx]->sp = (float) $this->convert->vest2sp($data[$idx]->vests, null);
    }
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function propsAction()
  {
    $data = PropsHistory::find([
      [],
      'sort' => array('date' => -1),
      'limit' => 500
    ]);
    foreach($data as $idx => $document) {
      $data[$idx] = $document->toArray();
    }
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function percentageAction()
  {
    $results = PropsHistory::find([
      [],
      'sort' => array('date' => -1),
      'limit' => 500
    ]);
    $data = [];
    foreach($results as $doc) {
      $key = $doc->time->toDateTime()->format("U");
      $data[$key] = $doc->total_vesting_fund_dpay / $doc->current_supply;
    }
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function debtloadAction()
  {
    $results = PropsHistory::find([
      [],
      'sort' => array('time' => -1),
      'limit' => 500
    ]);
    $data = [];
    foreach($results as $doc) {
      $key = $doc->time->toDateTime()->format("U");
      $data[$key] = 1 - ($doc->current_supply / $doc->virtual_supply);
    }
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function rsharesAction() {
    $data = Comment::rsharesAllocation()->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function downvotesAction() {
    $data = Comment::agg([
      [
        '$match' => [
          'created' => [
            '$gte' => new UTCDateTime(strtotime("-30 days") * 1000),
            '$lte' => new UTCDateTime(strtotime("midnight") * 1000),
          ]
        ]
      ],
      [
        '$project' => [
          'active_votes' => 1,
        ]
      ],
      [
        '$unwind' => '$active_votes'
      ],
      [
        '$match' => [
          'active_votes.percent' => ['$lt' => 0]
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'voter' => '$active_votes.voter',
            'doy' => ['$dayOfYear' => '$active_votes.time'],
            'year' => ['$year' => '$active_votes.time'],
            'month' => ['$month' => '$active_votes.time'],
            'day' => ['$dayOfMonth' => '$active_votes.time'],
          ],
          'downvotes' => [
            '$sum' => 1
          ],
        ]
      ],
      [
        '$sort' => [
          'downvotes' => -1
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => '$_id.doy',
            'year' => '$_id.year',
            'month' => '$_id.month',
            'day' => '$_id.day',
          ],
          'downvoters' => [
            '$sum' => 1
          ],
          'accounts' => [
            '$push' => [
              'voter' => '$_id.voter',
              'votes' => '$downvotes',
            ]
          ]
        ]
      ],
      [
        '$project' => [
          '_id' => '$_id',
          'total_voters' => '$total_voters',
          'total_rshares' => '$total_rshares',
          'total_vshares' => '$total_vshares',
          'accounts' => [
            '$slice' => [
              '$accounts', 20
            ]
          ]
        ]
      ],
      [
        '$sort' => [
          '_id.year' => 1,
          '_id.doy' => 1
        ]
      ]
      // [
      //   '$limit' => 10
      // ]
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();
    header('Content-type:application/json');
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function topwitnessesAction() {
    $witnesses = Witness::find(array(
      array(
      ),
      "sort" => array(
        'votes' => -1
      ),
      "limit" => 50
    ));
    $data = array();
    foreach($witnesses as $witness) {
      $data[$witness->owner] = Account::agg(array(
        ['$match' => [
            'witness_votes' => $witness->owner,
        ]],
        ['$project' => [
          'name' => '$name',
          'weight' => ['$sum' => ['$vesting_shares', '$proxy_witness']]
        ]],
        ['$sort' => ['weight' => -1]]
      ))->toArray();
    }
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function accountsAction() {

    $query = array();
    $sorting = array();

    $filter = $this->request->get('sort');
    switch($filter) {
      case "bbd":
        $sorting = array('total_bbd_balance' => -1);
        break;
      case "dpay":
        $sorting = array('total_balance' => -1);
        break;
      case "vest":
        $sorting = array('vesting_balance' => -1);
        break;
      case "reputation":
        $sorting = array('reputation' => -1);
        break;
      case "followers":
        $sorting = array('followers_count' => -1);
        break;
    }

    $account = $this->request->get('account');
    if($account) {
      if(is_array($account)) {
        $query['name'] = ['$in' => $account];
      } else {
        $query['name'] = (string) $account;
      }

    }

    $page = $this->request->get('page') ?: 1;
    $perPage = 100;
    $skip = $perPage * ($page - 1);

    $data = Account::find(array(
      $query,
      "sort" => $sorting,
      "limit" => $perPage,
      "skip" => $skip
    ));

    foreach($data as $idx => $document) {
      $data[$idx] = $document->toArray();
    }

    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function powerupAction() {
    $transactions = Block30d::agg([
      [
        '$match' => [
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
          '_id' => '$date',
          'count' => ['$sum' => 1],
          'instances' => ['$addToSet' => '$target.amount']
        ],
      ],
      [
        '$sort' => [
          '_id.year' => 1,
          '_id.doy' => 1
        ]
      ]
    ])->toArray();
    foreach($transactions as $idx => $tx) {
      $transactions[$idx]['total'] = 0;
      foreach($tx['instances'] as $powerup) {
        $transactions[$idx]['total'] += (float) explode(" ", $powerup)[0];
      }
      unset($transactions[$idx]['instances']);
    }
    echo json_encode($transactions, JSON_PRETTY_PRINT);
  }

  public function rewardsAction() {
    $rewards = AuthorReward::agg([
      [
        '$match' => [
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-90 days") * 1000),
            '$lte' => new UTCDateTime(strtotime("midnight") * 1000),
          ]
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$_ts'],
            'year' => ['$year' => '$_ts'],
            'month' => ['$month' => '$_ts'],
            'week' => ['$week' => '$_ts'],
            'day' => ['$dayOfMonth' => '$_ts']
          ],
          'count' => ['$sum' => 1],
          'bbd' => ['$sum' => '$bbd_payout'],
          'dpay' => ['$sum' => '$dpay_payout'],
          'vest' => ['$sum' => '$vesting_payout']
        ]
      ],
      [
        '$sort' => [
          '_id.year' => 1,
          '_id.doy' => 1
        ]
      ]
    ])->toArray();
    echo json_encode($rewards, JSON_PRETTY_PRINT);
  }

  public function curationAction() {
    $rewards = CurationReward::agg([
      [
        '$match' => [
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-90 days") * 1000),
            '$lte' => new UTCDateTime(strtotime("midnight") * 1000),
          ]
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$_ts'],
            'year' => ['$year' => '$_ts'],
            'month' => ['$month' => '$_ts'],
            'week' => ['$week' => '$_ts'],
            'day' => ['$dayOfMonth' => '$_ts']
          ],
          'count' => ['$sum' => 1],
          'vest' => ['$sum' => '$reward'],
        ]
      ],
      [
        '$sort' => [
          '_id.year' => 1,
          '_id.doy' => 1
        ]
      ]
    ])->toArray();
    echo json_encode($rewards, JSON_PRETTY_PRINT);
  }

  public function powerdown1000Action() {
    $accounts = Account::agg([
      ['$sort' => [
        'vesting_shares' => -1
        ]],
      ['$limit' => 1000]
    ])->toArray();
    $count = 0;
    foreach($accounts as $account) {
      if($account->next_vesting_withdrawal->toDateTime()->getTimestamp() > 0) {
        $count++;
      }
    }
    echo $count . " / 1000"; exit;
  }

}
