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
    $this->view->witnesses = Witness::find(array(
      array(
      ),
      "sort" => array(
        'votes' => -1
      ),
      "limit" => 100
    ));
  }
}
