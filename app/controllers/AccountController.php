<?php
namespace SteemDB\Controllers;

use SteemDB\Models\Account;
use SteemDB\Models\AccountHistory;
use SteemDB\Models\Block;
use SteemDB\Models\Comment;
use SteemDB\Models\Vote;

class AccountController extends ControllerBase
{

  public function listAction()
  {
    $filter = $this->dispatcher->getParam("filter");
    $query = array();
    $sort = array(
      "vesting_shares" => -1,
    );
    if($filter) {
      switch($filter) {
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
            "followers" => -1,
          );
          break;
        default:
          break;
      }
    }
    $limit = 50;
    $this->view->accounts = Account::find(array(
      $query,
      "sort" => $sort,
      "limit" => $limit
    ));
  }

  public function viewAction()
  {
    $account = $this->dispatcher->getParam("account");
    $this->view->activity = array_reverse($this->steemd->getAccountHistory($account));
    $this->view->account = Account::findFirst(array(
      array(
        'name' => $account
      )
    ));
    if(!$this->view->account) {
      $this->flashSession->error('The account "'.$account.'" does not exist on SteemDB currently.');
      $this->response->redirect();
      return;
    }
    $this->view->mining = Block::find(array(
      array(
        'witness' => $account,
      ),
      'sort' => array('_ts' => -1),
      'limit' => 100
    ));
    $this->view->comments = Comment::find(array(
      array(
        'author' => $account,
        'depth' => 0,
      ),
      'sort' => array('created' => -1),
      'limit' => 100
    ));
    $this->view->replies = Comment::find(array(
      array(
        'author' => $account,
        'depth' => ['$gt' => 0],
      ),
      'sort' => array('created' => -1),
      'limit' => 100
    ));
    $this->view->votes = Vote::find(array(
      array(
        'voter' => $account,
      ),
      'sort' => array('_ts' => -1),
      'limit' => 100
    ));
    $this->view->witnessing = Account::find(array(
      array(
        'witness_votes' => $account,
      ),
      'sort' => array('vesting_shares' => -1)
    ));
  }
}
