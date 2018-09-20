<?php
namespace SteemDB\Controllers;

use MongoDB\BSON\Regex;

use SteemDB\Models\Account;
use SteemDB\Models\Comment;
use SteemDB\Models\Reblog;

class ForumsController extends ControllerBase
{

  public $config = [
    'general' => [
      'name' => 'General Discussions',
      'description' => '',
      'boards' => [
        'introductions' => [
          'name' => 'Introductions',
          'description' => '',
          'tags' => ['introduceyourself']
        ],
        'blogs' => [
          'name' => 'Blogs',
          'description' => '',
          'tags' => [
            'blog',
            'life',
          ]
        ],
        'finance' => [
          'name' => 'Finance/Money',
          'description' => '',
          'tags' => [
            'finance',
            'money',
            'investing',
            'market',
          ]
        ],
        'politics' => [
          'name' => 'News/Politics',
          'description' => '',
          'tags' => [
            'politics',
            'news',
          ]
        ],
        'science' => [
          'name' => 'Science',
          'description' => '',
          'tags' => [
            'science',
            'physics',
            'biology',
            'technology',
          ]
        ],
      ],
    ],
    'chinese' => [
      'name' => 'CN',
      'description' => '',
      'boards' => [
        'cn-general' => [
          'name' => 'General',
          'description' => '',
          'tags' => [
            'cn'
          ]
        ],
        'cn-programming' => [
          'name' => 'Programming',
          'description' => '',
          'tags' => [
            'cn-programming'
          ]
        ],
      ]
    ],
    'creative' => [
      'name' => 'Creative',
      'description' => '',
      'boards' => [
        'audio' => [
          'name' => 'Audio',
          'description' => '',
          'tags' => ['audio', 'music', 'podcast']
        ],
        'food' => [
          'name' => 'Food',
          'description' => '',
          'tags' => [
            'food',
            'recipe',
            'cooking',
          ]
        ],
        'visual' => [
          'name' => 'Visual',
          'description' => '',
          'tags' => [
            'art',
            'photography',
            'photo'
          ]
        ],
        'writing' => [
          'name' => 'Writing',
          'description' => '',
          'tags' => [
            'story',
            'poetry',
            'fiction',
            'writing'
          ]
        ],
      ]
    ],
    'technology' => [
      'name' => 'Technology',
      'description' => '',
      'boards' => [
        'crypto' => [
          'name' => 'Cryptocurrencies',
          'description' => '',
          'tags' => [
            'cryptocurrency',
            'altcoin',
            'mining',
          ]
        ],
        'programming' => [
          'name' => 'Programming',
          'description' => '',
          'tags' => [
            'programming',
            'development',
            'dev',
            'coding'
          ]
        ]
      ]
    ],
    'steem' => [
      'name' => 'STEEM Discussion',
      'description' => '',
      'boards' => [
        'announcements' => [
          'name' => 'Announcements',
          'description' => '',
          'accounts' => [
            'steemitblog'
          ]
        ],
        'steem' => [
          'name' => 'Steem',
          'description' => '',
          'tags' => [
            'steem',
            'steemit',
          ]
        ],
        'witnesses' => [
          'name' => 'Witnesses',
          'description' => '',
          'tags' => [
            'witness-category',
            'witness-update',
          ]
        ],
      ]
    ],
  ];

  protected function getConfig($forum)
  {
    foreach($this->config as $category) {
      if(isset($category['boards'][$forum])) {
        return $category['boards'][$forum];
      }
    }
    return null;
  }

  protected function getCategory($forum)
  {
    foreach($this->config as $category => $data) {
      if(isset($data['boards'][$forum])) {
        return $category;
      }
    }
    return null;
  }

  protected function getForumByTag($tag)
  {
    foreach($this->config as $category => $data) {
      foreach($data['boards'] as $forum_id => $forum) {
        if(isset($forum['tags']) && in_array($tag, $forum['tags'])) {
          return $forum_id;
        }
      }
    }
    return null;
  }

  protected function getQuery($forum) {
    $query = array(
      'depth' => 0,
    );
    if(isset($forum['tags'])) {
      $query['category'] = ['$in' => $forum['tags']];
    }
    if(isset($forum['accounts'])) {
      $query['author'] = ['$in' => $forum['accounts']];
    }
    return $query;
  }

  protected function queryPlanner($command) {
    $output = array();
    $manager = new \MongoDB\Driver\Manager("mongodb://mongo:27017");
    // $cmd = new \MongoDB\Driver\Command([
    //   'explain' => $command,
    //   'verbosity' => 'queryPlanner',
    // ]);
    // $cursor = $manager->executeCommand('steemdb', $cmd); // retrieve the results
    // $output['queryPlanner'] = $cursor->toArray()[0];
    $cmd = new \MongoDB\Driver\Command([
      'explain' => $command,
      'verbosity' => 'allPlansExecution',
    ]);
    $cursor = $manager->executeCommand('steemdb', $cmd); // retrieve the results
    // $output['executionStats'] = $cursor->toArray()[0];
    return $cursor->toArray()[0];
    return $output;
  }

  public function postAction()
  {

  }

  public function indexAction()
  {
    $forums = $this->config;

    $this->view->perfLogger = $perfLogger = $this->request->get('perfLogger', 'int');
    $perfLog = array();

    foreach($forums as $category_id => $category) {
      foreach($category['boards'] as $board_id => $board) {
        $query = $this->getQuery($board);
        $sort = [
          'last_reply' => -1,
          'created' => -1,
        ];
        $limit = 1;

        if($board_id == 'general') continue; // Too much of a memory hog atm

        // Check performance of queries
        if($perfLogger) {
          $perfLog[$board_id] = array(
            'count' => $this->queryPlanner([
              'count' => 'comment',
              'filter' => $query,
            ]),
            'find' => $this->queryPlanner([
              'find' => 'comment',
              'filter' => $query,
              'sort' => $sort,
              'limit' => $limit,
            ]),
          );
        }

        $forums[$category_id]['boards'][$board_id]['posts'] = Comment::count([
             $query
        ]);
        $forums[$category_id]['boards'][$board_id]['recent'] = Comment::find([
             $query,
             'sort' => $sort,
             'limit' => $limit,
        ])[0];
      }
    }
    $this->view->perfLog = $perfLog;
    $this->view->forums = $forums;
  }

  public function boardAction()
  {
    // Forum Configuration
    $this->view->forum_key = $forum = $this->dispatcher->getParam("forum", "string");
    if($forum) {
      $this->view->forum = $this->getConfig($forum);
      $this->view->category = $this->getCategory($forum);
      $this->view->category_key = $forum;
      $this->view->categories = $this->config;
      $query = $this->getQuery($this->view->forum);
    }
    // Tag Configuration
    $this->view->tag = $tag = $this->dispatcher->getParam("tag", "string");
    if($tag) {
      $this->view->forum = $forum = [
        'name' => "#".$tag,
        'description' => 'Posts tagged with #'.$tag,
        'tags' => [$tag]
      ];
      $query = $this->GetQuery($forum);
      $this->view->form = $forum;
    }
    $page = $this->view->page = (int) $this->request->get('page') ?: 1;
    $sort = array(
      'last_reply' => -1,
      'created' => -1,
    );
    $limit = 10;
    $this->view->pages = ceil(Comment::count([
         $query
    ]) / $limit);
    $this->view->topics = Comment::find([
      $query,
      "sort" => $sort,
      "limit" => $limit,
      'skip' => $limit * ($page - 1)
    ]);
  }
  public function viewAction()
  {
    $tag = $this->dispatcher->getParam("tag", "string");
    $author = $this->dispatcher->getParam("author", "string");
    $permlink = $this->dispatcher->getParam("permlink", "string");

    $this->view->forum_key = $forum = $this->getForumByTag($tag);
    if($forum) {
      $this->view->forum = $this->getConfig($forum);
      $this->view->category = $this->getCategory($forum);
      $this->view->category_key = $forum;
      $this->view->categories = $this->config;
    }

    $query = array(
      'url' => [
        '$regex' => new Regex(sprintf('^\/%s\/@%s\/%s(#|$)', $tag, $author, $permlink), 'i')
      ],
    );

    $sort = array(
      'created' => 1,
    );

    $this->view->posts = Comment::find([
      $query,
      "sort" => $sort,
    ]);

    // find resteems
    $this->view->resteems = Reblog::count([
      [
        'author' => $author,
        'permlink' => $permlink,
      ]
    ]);

    // Messy "get it done" loading of authors
    $this->view->unique_authors = $unique_authors = array_values(array_unique(array_column($this->view->posts, 'author')));
    $query = ['name' => ['$in' => $unique_authors]];
    $accounts = Account::find([
      $query,
      "sort" => $sort,
    ]);
    $authors = [];
    foreach($accounts as $account) {
      $authors[$account->name] = $account;
    }
    $this->view->authors = $authors;
  }
}
