<?php
namespace BexNetwork\Controllers;

use MongoDB\BSON\UTCDateTime;
use MongoDB\BSON\ObjectID;

use BexNetwork\Models\Witness;
use BexNetwork\Models\WitnessMiss;
use BexNetwork\Models\WitnessVote;
use BexNetwork\Models\Statistics;

class WitnessController extends ControllerBase
{
  public function listAction()
  {
    $this->view->queue = Statistics::findFirst(array(
      array(
        "key" => "miner_queue"
      )
    ));
    $witnesses = Witness::agg(array(
      [
        '$sort' => [
          'votes' => -1
        ]
      ],
      [
        '$limit' => 100
      ],
      [
        '$lookup' => [
          'from' => 'account',
          'localField' => 'owner',
          'foreignField' => 'name',
          'as' => 'account',
        ]
      ],
    ))->toArray();
    $pipeline = [
      [
        '$match' => [
          'date' => [
            '$gte' => new UTCDateTime(strtotime("-7 days") * 1000)
          ]
        ]
      ],
      [
        '$group' => [
          '_id' => '$witness',
          'total' => [
            '$sum' => '$increase'
          ]
        ]
      ]
    ];
    $agg = WitnessMiss::agg($pipeline)->toArray();
    foreach($agg as $data) {
      $misses[$data['_id']] = $data['total'];
    }
    foreach($witnesses as $index => $witness) {
      // Highlight Green for top 19
      if($index < 19) {
        $witness->row_status = "positive";
      }
      // Highlight Red is no price feed exists
      if($witness->bbd_exchange_rate->base === "0.000 BEX") {
        $witness->row_status = "warning";
      }
      // Highlight Red is price feed older than 24 hrs
      if((string) $witness->last_bbd_exchange_update <= strtotime("-1 week") * 1000) {
        $witness->row_status = "warning";
        $witness->last_bbd_exchange_update_late = true;
      }
      // Highlight Red if the signing key is invalid
      if(!$witness->signing_key || $witness->signing_key == "" || $witness->signing_key == "STM1111111111111111111111111111111114T1Anm") {
        $witness->row_status = "negative";
        $witness->invalid_signing_key = true;
      }
      // Add the new 7 day misses
      $witness->misses_7day = (isset($misses[$witness->owner]) ? $misses[$witness->owner] : 0);
    }
    $this->view->witnesses = $witnesses;
  }
  public function historyAction() {
    $this->view->votes = $votes = WitnessVote::agg([
      [
        '$sort' => ['_ts' => -1]
      ],
      [
        '$limit' => 100
      ],
      [
        '$lookup' => [
          'from' => 'account',
          'localField' => 'account',
          'foreignField' => 'name',
          'as' => '_account',
        ]
      ],
      [
        '$unwind' => '$_account'
      ],
      [
        '$project' => [
          '_id' => '$_id',
          'weight' => ['$sum' => ['$_account.vesting_shares', '$_account.proxy_witness']],
          'witness' => '$witness',
          'account' => '$account',
          'approve' => '$approve',
          '_ts' => '$_ts',
        ]
      ]
    ])->toArray();
    // var_dump($votes[2]->_account[0]->proxied_vsf_votes); exit;
    $this->view->misses = $misses = WitnessMiss::agg([
      [
        '$match' => [
          'date' => [
            '$gte' => new UTCDateTime(strtotime("-7 days") * 1000)
          ]
        ]
      ],
      [
        '$group' => [
          '_id' => '$witness',
          'total' => [
            '$sum' => '$increase'
          ]
        ]
      ],
      [
        '$sort' => ['total' => -1]
      ]
    ])->toArray();
  }
}
