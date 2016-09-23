<?php
namespace SteemDB\Controllers;

use MongoDB\BSON\Regex;
use MongoDB\BSON\UTCDateTime;

use SteemDB\Models\Account;
use SteemDB\Models\Block;
use SteemDB\Models\Comment;
use SteemDB\Models\Statistics;
use SteemDB\Models\Vote;
use SteemDB\Models\AccountHistory;
use SteemDB\Models\PropsHistory;
use SteemDB\Models\Witness;
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
          '_id.year' => -1,
          '_id.doy' => 1
        ]
      ]
    ];
    $data = Vote::aggregate($pipeline)->toArray();
    echo json_encode($pipeline, JSON_PRETTY_PRINT);
  }

  public function activityAction()
  {
    $data = Comment::aggregate([
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
          '_id.year' => -1,
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
    $data = Comment::aggregate([
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
          '_id.year' => -1,
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
    $data = AccountHistory::aggregate([
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
    $data = AccountHistory::aggregate([
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
          'sbd' => [
            '$sum' => '$sbd_balance'
          ],
          'steem' => [
            '$sum' => '$balance'
          ],
          'vests' => [
            '$sum' => '$vesting_shares'
          ]
        ],
      ],
      [
        '$sort' => [
          '_id.year' => -1,
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
      $data[$key] = $doc->total_vesting_fund_steem / $doc->current_supply;
    }
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function rsharesAction() {
    $data = Comment::rsharesAllocation()->toArray();
    echo json_encode($data, JSON_PRETTY_PRINT);
  }

  public function downvotesAction() {
    $data = Comment::aggregate([
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
      $data[$witness->owner] = Account::aggregate(array(
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

}
