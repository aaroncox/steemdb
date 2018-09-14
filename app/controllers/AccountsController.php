<?php
namespace BexNetwork\Controllers;

use BexNetwork\Models\Account;
use BexNetwork\Models\Statistics;

class AccountsController extends ControllerBase
{

  public function listAction()
  {
    $this->view->filter = $filter = $this->dispatcher->getParam("filter", "string");
    $this->view->page = $page = (int) $this->request->get("page") ?: 1;
    $query = array();
    $sort = array(
      "vesting_shares" => -1,
    );
    if($filter) {
      switch($filter) {
        case "powerdown":
          $sort = array(
            "vesting_withdraw_rate" => -1
          );
          break;
        case "followers_mvest":
          $sort = array(
            "followers_mvest" => -1,
          );
          break;
        case "bbd":
          $sort = array(
            "total_bbd_balance" => -1,
          );
          break;
        case "dpay":
          $sort = array(
            "total_balance" => -1,
          );
          break;
        case "reputation":
          $query['reputation'] = array('$gt' => 0);
          $sort = array(
            "reputation" => -1,
          );
          break;
        case "posts":
          $sort = array(
            "post_count" => -1,
          );
          break;
        case "followers":
          $sort = array(
            "followers_count" => -1,
          );
          break;
        default:
          break;
      }
    }
    $limit = 10;
    // Determine how many pages of users we have
    $this->view->pages = ceil(Statistics::findFirst(array(
      array('key' => 'users'),
      "sort" => array('date' => -1)
    ))->toArray()['value'] / $limit);
    // Load the accounts
    $this->view->accounts = Account::find(array(
      $query,
      "skip" => $limit * ($page - 1),
      "sort" => $sort,
      "limit" => $limit
    ));
  }

}
