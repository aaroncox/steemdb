<?php
namespace SteemDB\Controllers;

use SteemDB\Models\Status;
use SteemDB\Models\FundsHistory;

class IndexController extends ControllerBase
{
  public function indexAction()
  {
    return $this->response->redirect('/');
  }
  public function liveAction()
  {

  }

  public function homepageAction() {
    $this->view->props = $props = $this->steemd->getProps();
    $this->view->inflation = round(max((978 - $props['head_block_number'] / 250000), 95) / 100, 4);
    $this->view->totals = $totals = $this->util->distribution($props);
    # Transactions
    $tx = $results = Status::findFirst([['_id' => 'transactions-24h']]);
    $tx1h = Status::findFirst([['_id' => 'transactions-1h']]);
    $this->view->tx = $tx->data;
    $this->view->tx_per_sec = round($tx->data / 86400, 3);
    $this->view->tx1h = $tx1h->data;
    $this->view->tx1h_per_sec = round($tx1h->data / 3600, 3);
    # Operations
    $op = $results = Status::findFirst([['_id' => 'operations-24h']]);
    $op1h = Status::findFirst([['_id' => 'operations-1h']]);
    $this->view->op = $op->data;
    $this->view->op_per_sec = round($op->data / 86400, 3);
    $this->view->op1h = $op1h->data;
    $this->view->op1h_per_sec = round($op1h->data / 3600, 3);
    $this->view->funds = FundsHistory::find([
      ['name' => 'post'],
      'sort' => ['last_update' => -1],
      'limit' => 1
    ])[0];
  }

  public function show404Action() {

  }
}
