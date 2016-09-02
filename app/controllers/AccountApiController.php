<?php
namespace SteemDB\Controllers;

use MongoDB\BSON\ObjectID;
use MongoDB\BSON\Regex;
use MongoDB\BSON\UTCDateTime;

use SteemDB\Models\AccountHistory;
use SteemDB\Models\Block;
use SteemDB\Models\Comment;
use SteemDB\Models\Pow;
use SteemDB\Models\Statistics;
use SteemDB\Models\Vote;

class AccountApiController extends ControllerBase
{

  public function snapshotsAction() {
    $account = $this->dispatcher->getParam("account");
    $data = AccountHistory::find([
      ['account' => $account],
      'sort' => ['date' => 1],
      'limit' => 100
    ]);
    foreach($data as $idx => $document) {
      $data[$idx]->date = (string) $document->date;

    }
    echo json_encode($data); exit;
  }

  public function historyAction() {
    $account = $this->dispatcher->getParam("account");
    $data = AccountHistory::aggregate([
      [
        '$match' => [
          'name' => $account
        ]
      ],
      [
        '$project' => [
          '_id' => [
            'doy' => ['$dayOfYear' => '$date'],
            'year' => ['$year' => '$date'],
            'month' => ['$month' => '$date'],
            'day' => ['$dayOfMonth' => '$date'],
          ],
          'posts' => '$post_count',
          'followers' => '$followers',
          'posting_rewrds' => '$posting_rewards',
          'curation_rewards' => '$curation_rewards',
          'vests' => '$vesting_shares',
        ]
      ],
      [
        '$sort' => [
          'date' => -1
        ]
      ]
    ])->toArray();
    echo json_encode($data); exit;
  }

  public function miningAction() {
    $account = $this->dispatcher->getParam("account");
    $witness = Block::aggregate([
      [
        '$match' => [
          'witness' => $account,
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-45 days") * 1000),
          ],
        ]
      ],
      [
        '$project' => [
          'witness' => 1,
          '_ts' => 1,
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
          'blocks' => [
            '$sum' => 1
          ]
        ]
      ]
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();
    $pow = Pow::aggregate([
      [
        '$match' => [
          'work.input.worker_account' => $account,
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-45 days") * 1000),
          ],
        ]
      ],
      [
        '$project' => [
          'work.input.worker_account' => 1,
          '_ts' => 1,
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
          'blocks' => [
            '$sum' => 1
          ]
        ]
      ]
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();

    echo json_encode(['pow' => $pow, 'witness' => $witness]); exit;
  }

  public function votesAction() {
    $account = $this->dispatcher->getParam("account");
    $data = Vote::aggregate([
      [
        '$match' => [
          '$or' => [
            ['voter' => $account],
            ['author' => $account],
          ],
          '_ts' => [
            '$gte' => new UTCDateTime(strtotime("-45 days") * 1000),
          ],
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
          'votes' => [
            '$sum' => 1
          ],
          'incoming' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$author', $account]],
              1,
              0,
            ]],
          ],
          'outgoing' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$voter', $account]],
              1,
              0,
            ]],
          ],
        ]
      ],
      [
        '$sort' => [
          '_id.year' => -1,
          '_id.doy' => 1
        ]
      ]
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();
    echo json_encode($data); exit;
  }

  public function postsAction() {
    $account = $this->dispatcher->getParam("account");
    $data = Comment::aggregate([
      [
        '$match' => [
          'author' => $account,
          'created' => [
            '$gte' => new UTCDateTime(strtotime("-45 days") * 1000),
          ],
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
            '$sum' => ['$cond' => [
              ['$eq' => ['$depth', 0]],
              1,
              0,
            ]],
          ],
          'replies' => [
            '$sum' => ['$cond' => [
              ['$eq' => ['$depth', 0]],
              0,
              1,
            ]],
          ],
        ]
      ],
      [
        '$sort' => [
          '_id.year' => -1,
          '_id.doy' => 1
        ]
      ]
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ])->toArray();
    echo json_encode($data); exit;
  }

}
