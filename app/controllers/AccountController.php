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
    $query = array(
    );
    $sort = array(
      'vesting_shares' => -1,
    );
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
