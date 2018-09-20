<?php
namespace SteemDB\Controllers;

use SteemDB\Models\Block30d;

class BlocksController extends ControllerBase
{

  public function indexAction()
  {
    $this->view->blocks = Block30d::find([
      [],
      "skip" => $limit * ($page - 1),
      "sort" => ['_id' => -1],
      "limit" => 100
    ]);
  }

}
