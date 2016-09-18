<?php
namespace SteemDB\Controllers;

use MongoDB\BSON\UTCDateTime;
use MongoDB\BSON\ObjectID;

use SteemDB\Models\Witness;
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
    foreach($witnesses as $index => $witness) {
      // Highlight Green for top 19
      if($index < 19) {
        $witness->row_status = "positive";
      }
      // Highlight Red is no price feed exists
      if($witness->sbd_exchange_rate->base === "0.000 STEEM") {
        $witness->row_status = "negative";
      }
      // Highlight Red is price feed older than 24 hrs
      if((string) $witness->last_sbd_exchange_update <= strtotime("-1 week") * 1000) {
        $witness->row_status = "negative";
        $witness->last_sbd_exchange_update_late = true;
      }
    }
    $this->view->witnesses = $witnesses;
  }
}
