<?php
namespace SteemDB\Controllers;

use SteemDB\Models\Account;
use SteemDB\Models\Block;
use SteemDB\Models\Comment;

use MongoDB\BSON\Regex;

class SearchController extends ControllerBase
{
  public function indexAction()
  {
    $query = $this->request->get("q");
    $accounts = Account::find(array(
      array(
        'name' => new Regex('^'.$query, 'i')
      ),
      "sort" => [
        "followers" => -1
      ],
      "fields" => [
        'name' => 1
      ],
      "limit" => 5
    ));
    $data = [
      'results' => [
        'accounts' => [
          'name' => 'Accounts',
          'results' => array_map(function($account) {
            return [
              'title' => $account->name,
              'url' => '/@'.$account->name
            ];
          }, $accounts)
        ]
      ]
    ];
    $this->view->disable();
    $this->response->setContentType('application/json', 'UTF-8');
    $this->response->setJsonContent($data);
    return $this->response;
  }
}
