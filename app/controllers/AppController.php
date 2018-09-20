<?php
namespace SteemDB\Controllers;

use MongoDB\BSON\UTCDateTime;

use SteemDB\Models\AuthorReward;
use SteemDB\Models\BenefactorReward;
use SteemDB\Models\Status;

class AppController extends ControllerBase
{

  protected $apps = [
    'busy' => [
      'name' => 'Busy',
      'apptag' => 'busy',
      'beneficiary' => '',
      'description' => '',
      'link' => 'https://busy.org',
    ],
    'chainbb' => [
      'name' => 'chainBB',
      'apptag' => 'chainbb',
      'beneficiary' => 'chainbb',
      'description' => 'Steem blockchain powered discussion forum',
      'link' => 'https://beta.chainbb.com',
    ],
    'dsound' => [
      'name' => 'dsound',
      'apptag' => 'dsound',
      'beneficiary' => 'dsound',
      'description' => 'A decentralized audio platform using STEEM and IPFS',
      'link' => 'https://dsound.audio',
    ],
    'dtube' => [
      'name' => 'dtube',
      'apptag' => 'dtube',
      'beneficiary' => 'dtube',
      'description' => 'A decentralized video platform using STEEM and IPFS',
      'link' => 'https://dtube.video',
    ],
    'esteem' => [
      'name' => 'eSteem',
      'apptag' => 'esteem',
      'beneficiary' => 'esteemapp',
      'description' => '',
      'link' => 'https://esteem.ws',
    ],
    'steemit' => [
      'name' => 'Steemit',
      'apptag' => 'steemit',
      'beneficiary' => '',
      'description' => '',
      'link' => 'https://steemit.com',
    ],
    'steepshot' => [
      'name' => 'steepshot',
      'apptag' => 'steepshot',
      'beneficiary' => 'steepshot',
      'description' => '',
      'link' => 'https://steepshot.io',
    ],
    'utopian' => [
      'name' => 'Utopian.io',
      'apptag' => 'utopian',
      'beneficiary' => 'utopian-io',
      'description' => 'Rewarding Open Source Contributors',
      'link' => 'https://utopian.io',
    ],
    'zappl' => [
      'name' => 'zappl',
      'apptag' => 'zappl',
      'beneficiary' => 'zappl',
      'description' => 'Censor resistant micro blogging',
      'link' => 'https://zappl.com',
    ],
  ];

  protected function getApp() {
    $this->view->app = $app = strtolower($this->dispatcher->getParam("app"));
    $this->view->meta = $meta = $this->apps[$app];
    $this->view->pick("app/view");
    return $meta;
  }

  public function viewAction()
  {
    $meta = $this->getApp();
    $this->view->leaderboard = AuthorReward::aggregate([
      ['$match' => [
        'app_name' => $meta['apptag'],
        '_ts' => [
          '$gte' => new UTCDateTime(strtotime("-30 days") * 1000)
        ]
      ]],
      ['$sort' => [
        '_ts' => -1
      ]],
      ['$project' => [
        '_ts' => 1,
        'author' => 1,
        'sbd_payout' => 1,
        'steem_payout' => 1,
        'vesting_payout' => 1,
        'value' => [
          '$sum' => [
            '$vesting_payout',
            ['$cond' => [
              ['$and' => [
                ['$eq' => ['$steem_payout', 0]],
                ['$eq' => ['$sbd_payout', 0]],
              ]],
              '$vesting_payout',
              ['$multiply' => ['$vesting_payout', 2]]
            ]]
          ]
        ]
      ]],
      ['$group' => [
        '_id' => [
          'account' => '$author',
        ],
        'sbd' => ['$sum' => '$sbd_payout'],
        'steem' => ['$sum' => '$steem_payout'],
        'vests' => ['$sum' => '$vesting_payout'],
        'value' => ['$sum' => '$value'],
        'count' => ['$sum' => 1]
      ]],
      ['$sort' => [
        'value' => -1,
        '_id.year' => -1,
        '_id.doy' => -1
      ]],
      ['$limit' => 1000]
    ])->toArray();
    // var_dump($this->view->leaderboard); exit;
  }

  public function earningsAction()
  {
    $meta = $this->getApp();
    $results = BenefactorReward::aggregate([
      ['$match' => [
        'benefactor' => $meta['beneficiary'],
      ]],
      ['$sort' => [
        '_ts' => -1
      ]],
      ['$group' => [
        '_id' => [
          'doy' => ['$dayOfYear' => '$_ts'],
          'year' => ['$year' => '$_ts'],
          'month' => ['$month' => '$_ts'],
          'day' => ['$dayOfMonth' => '$_ts'],
          'dow' => ['$dayOfWeek' => '$_ts'],
        ],
        'reward' => ['$sum' => '$reward'],
        'count' => ['$sum' => 1]
      ]],
      ['$sort' => [
        '_id.year' => -1,
        '_id.doy' => -1
      ]]
    ])->toArray();
    $this->view->rewards = $results;
    $this->view->stats = BenefactorReward::agg([
      [
        '$match' => [
          'benefactor' => $meta['beneficiary']
        ]
      ],
      [
        '$group' => [
          '_id' => '$benefactor',
          'week' => ['$sum' => ['$cond' => [
            [
              '$gte' => [
                '$_ts',
                new UTCDateTime(strtotime("-7 days") * 1000)
              ]
            ],
            '$reward',
            0
          ]]],
          'month' => ['$sum' => ['$cond' => [
            [
              '$gte' => [
                '$_ts',
                new UTCDateTime(strtotime("-30 days") * 1000)
              ]
            ],
            '$reward',
            0
          ]]],
          'quarter' => ['$sum' => ['$cond' => [
            [
              '$gte' => [
                '$_ts',
                new UTCDateTime(strtotime("-90 days") * 1000)
              ]
            ],
            '$reward',
            0
          ]]],
        ]
      ]
    ])->toArray();
  }

}
