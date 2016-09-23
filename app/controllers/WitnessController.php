<?php
namespace SteemDB\Controllers;

use MongoDB\BSON\UTCDateTime;
use MongoDB\BSON\ObjectID;

use SteemDB\Models\Witness;
use SteemDB\Models\WitnessMiss;
use SteemDB\Models\Statistics;

class WitnessController extends ControllerBase
{
  public function listAction()
  {
    $this->view->queue = Statistics::findFirst(array(
      array(
        "key" => "miner_queue"
      )
    ));
    $witnesses = Witness::find(array(
      array(
      ),
      "sort" => array(
        'votes' => -1
      ),
      "limit" => 100
    ));
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
    $aggregate = WitnessMiss::aggregate($pipeline)->toArray();
    foreach($aggregate as $data) {
      $misses[$data['_id']] = $data['total'];
    }
    foreach($witnesses as $index => $witness) {
      // Highlight Green for top 19
      if($index < 19) {
        $witness->row_status = "positive";
      }
      // Highlight Red is no price feed exists
      if($witness->sbd_exchange_rate->base === "0.000 STEEM") {
        $witness->row_status = "warning";
      }
      // Highlight Red is price feed older than 24 hrs
      if((string) $witness->last_sbd_exchange_update <= strtotime("-1 week") * 1000) {
        $witness->row_status = "warning";
        $witness->last_sbd_exchange_update_late = true;
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
}
