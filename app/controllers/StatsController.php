<?php
namespace SteemDB\Controllers;

use MongoDB\BSON\UTCDateTime;

use SteemDB\Models\AuthorReward;
use SteemDB\Models\CurationReward;

class StatsController extends ControllerBase
{

  public function indexAction()
  {
    $this->view->props = $props = $this->steemd->getProps();
    $this->view->totals = $totals = $this->util->distribution($props);
    var_dump($totals); exit;
  }

}
