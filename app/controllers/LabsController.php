<?php
namespace SteemDB\Controllers;

use SteemDB\Models\Comment;
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
}
