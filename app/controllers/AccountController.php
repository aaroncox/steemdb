<?php
namespace SteemDB\Controllers;

use SteemDB\Models\Account;
use SteemDB\Models\AccountHistory;
use SteemDB\Models\Block;
use SteemDB\Models\Comment;
use SteemDB\Models\Follow;
use SteemDB\Models\Vote;
use SteemDB\Models\Statistics;
use SteemDB\Models\WitnessMiss;

class AccountController extends ControllerBase
{

  private function getAccount()
  {
    $account = $this->dispatcher->getParam("account");
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
    return $account;
  }

  public function viewAction()
  {
    $account = $this->getAccount();
    try {
      $this->view->activity = array_reverse($this->steemd->getAccountHistory($this->view->account->name));
    } catch (Exception $e) {
      $this->view->activity = false;
    }
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
    $this->view->chart = true;
    $this->view->pick("account/view");
  }

  public function postsAction()
  {
    $account = $this->getAccount();
    $this->view->comments = Comment::find(array(
      array(
        'author' => $account,
        'depth' => 0,
      ),
      'sort' => array('created' => -1),
      'limit' => 100
    ));
    $this->view->total_payouts = 0;
    $this->view->total_pending = 0;
    foreach($this->view->comments as $comment) {
      if($comment->total_pending_payout_value) {
        $this->view->total_pending += $comment->total_pending_payout_value;
      }
      if($comment->total_payout_value) {
        $this->view->total_payouts += $comment->total_payout_value;
      }
    }
    $this->view->chart = true;
    $this->view->pick("account/view");
  }

  public function votesAction()
  {
    $account = $this->getAccount();
    $this->view->filter = $this->request->get('type');
    switch($this->view->filter) {
      case "incoming":
        $query = array(
          'author' => $account,
        );
        break;
      default:
        $query = array(
          'voter' => $account,
        );
        break;
    }
    $this->view->votes = Vote::find(array(
      $query,
      'sort' => array('_ts' => -1),
      'limit' => 100
    ));
    $this->view->chart = true;
    $this->view->pick("account/view");
  }

  public function repliesAction()
  {
    $account = $this->getAccount();
    $this->view->replies = Comment::find(array(
      array(
        'author' => $account,
        'depth' => ['$gt' => 0],
      ),
      'sort' => array('created' => -1),
      'limit' => 100
    ));
    $this->view->pick("account/view");
  }

  public function followersAction()
  {
    $account = $this->getAccount();
    $this->view->followers = Follow::find([
      ["following" => $account],
      "sort" => ['_ts' => -1]
    ]);
    $this->view->pick("account/view");
  }

  public function followingAction()
  {
    $account = $this->getAccount();
    $this->view->followers = Follow::find([
      ["follower" => $account],
      "sort" => ['_ts' => -1]
    ]);
    $this->view->pick("account/view");
  }

  public function witnessAction()
  {
    $account = $this->getAccount();
    $this->view->witnessing = Account::aggregate(array(
      ['$match' => [
          'witness_votes' => $account,
      ]],
      ['$project' => [
        'name' => '$name',
        'weight' => ['$sum' => ['$vesting_shares', '$proxy_witness']]
      ]],
      ['$sort' => ['weight' => -1]]
    ))->toArray();
    $this->view->witness_votes = array_sum(array_map(function($item) {
      return $item['weight'];
    }, $this->view->witnessing));
    $this->view->chart = true;
    $this->view->pick("account/view");
  }

  public function blocksAction()
  {
    $account = $this->getAccount();
    $this->view->mining = Block::find(array(
      array(
        'witness' => $account,
      ),
      'sort' => array('_ts' => -1),
      'limit' => 100
    ));
    $this->view->chart = true;
    $this->view->pick("account/view");
  }

  public function missedAction()
  {
    $account = $this->getAccount();
    $this->view->mining = WitnessMiss::find(array(
      array(
        'witness' => $account,
      ),
      'sort' => array('date' => -1),
      'limit' => 100
    ));
    $this->view->pick("account/view");
  }

  public function dataAction()
  {
    $account = $this->getAccount();
    $this->view->pick("account/view");
  }
}
