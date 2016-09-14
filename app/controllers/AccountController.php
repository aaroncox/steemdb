<?php
namespace SteemDB\Controllers;

use SteemDB\Models\Account;
use SteemDB\Models\AccountHistory;
use SteemDB\Models\Block;
use SteemDB\Models\Comment;
use SteemDB\Models\Vote;
use SteemDB\Models\Statistics;

class AccountController extends ControllerBase
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

  public function viewAction()
  {
    $account = $this->dispatcher->getParam("account");
    try {
      $this->view->activity = array_reverse($this->steemd->getAccountHistory($account));
    } catch (Exception $e) {
      $this->view->activity = false;
    }
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
    $this->view->followers = Account::find([
      ['name' => ['$in' => $this->view->account->followers]],
      'sort' => ['vesting_shares' => -1],
    ]);
    $this->view->following = Account::find([
      ['name' => ['$in' => $this->view->account->following]],
      'sort' => ['vesting_shares' => -1],
    ]);
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
  }
}
