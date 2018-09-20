<?php
/*
 * Define custom routes. File gets included in the router service definition.
 */
$router = new Phalcon\Mvc\Router();
$router->removeExtraSlashes(true);

/*
  account view routes
*/

$router->add('/@([-a-zA-Z0-9.]+)', [
  'controller' => 'account',
  'action' => 'view',
  'account' => 1
])->setName("account-view");

$router->add('/@([-a-zA-Z0-9.]+)/([-a-zA-Z0-9]+)', [
  'controller' => 'account',
  'account' => 1,
  'action' => 2
])->setName("account-view-section");

$router->add('/@([-a-zA-Z0-9.]+)/curation/([-0-9]+)', [
  'controller' => 'account',
  'account' => 1,
  'date' => 2,
  'action' => 'curationDate'
])->setName("account-view-curation-date");

$router->add('/@([-a-zA-Z0-9.]+)/beneficiaries/([-0-9]+)', [
  'controller' => 'account',
  'account' => 1,
  'date' => 2,
  'action' => 'beneficiariesDate'
])->setName("account-view-beneficiaries-date");

$router->add('/@([-a-zA-Z0-9.]+)/authoring/([-0-9]+)', [
  'controller' => 'account',
  'account' => 1,
  'date' => 2,
  'action' => 'authoringDate'
])->setName("account-view-authoring-date");

$router->add('/@([-a-zA-Z0-9.]+)/followers/whales', [
  'controller' => 'account',
  'account' => 1,
  'action' => 'followersWhales'
]);

/*
  accounts aggregation
*/

$router->add('/accounts[/]?{filter}?', [
  'controller' => 'accounts',
  'action' => 'list'
]);

/*
  app views
*/

$router->add('/app/([-a-zA-Z0-9.]+)', [
  'controller' => 'app',
  'action' => 'view',
  'app' => 1
])->setName("app-view");

$router->add('/app/([-a-zA-Z0-9.]+)/([-a-zA-Z0-9]+)', [
  'controller' => 'app',
  'app' => 1,
  'action' => 2
])->setName("app-view-section");

/*
  block routes
*/

$router->add('/block/([a-zA-Z0-9]+)', [
  'controller' => 'block',
  'action' => 'view',
  'height' => 1
])->setName("block-view");

$router->add('/tx/([a-zA-Z0-9]+)', [
  'controller' => 'tx',
  'action' => 'view',
  'id' => 1
])->setName("tx-view");

/*
  comment viewing routes
*/

$router->add('/([-a-zA-Z0-9.]+)/@([-a-zA-Z0-9.]+)/([-a-zA-Z0-9.]+)', [
  'controller' => 'comment',
  'action' => 'view',
  'category' => 1,
  'author' => 2,
  'permlink' => 3,
])->setName("comment-view");

$router->add('/([-a-zA-Z0-9.]+)/@([-a-zA-Z0-9.]+)/([-a-zA-Z0-9.]+)/{action}', [
  'controller' => 'comment',
  'category' => 1,
  'author' => 2,
  'permlink' => 3,
  'action' => 4,
])->setName("comment-view-section");

/*
  lab routes
*/

$router->add('/powerup', [
  'controller' => 'labs',
  'action' => 'powerup'
]);

$router->add('/powerdown', [
  'controller' => 'labs',
  'action' => 'powerdown'
]);

/*
  comment aggregation routes
*/

$router->add('/posts', [
  'controller' => 'comments',
  'action' => 'list'
]);

$router->add('/', [
  'controller' => 'index',
  'action' => 'homepage'
]);

$router->add('/posts/{tag}/{sort}/{date}', [
  'controller' => 'comments',
  'action' => 'daily'
]);

/*
  witness routes
*/

$router->add('/witnesses', [
  'controller' => 'witness',
  'action' => 'list'
]);

/*
  API routes
*/

$router->add('/api/tags/{tag}', [
  'controller' => 'api',
  'action' => 'tags'
]);

$router->add('/api/account/{account}', [
  'controller' => 'account_api',
  'action' => 'view'
]);

$router->add('/api/account/{account}/{action}', [
  'controller' => 'account_api'
]);

/*
  forum routes
*/

$router->add('/forums/{forum}', [
  'controller' => 'forums',
  'action' => 'board'
]);

$router->add('/forums/{forum}/post', [
  'controller' => 'forums',
  'action' => 'post'
]);

$router->add('/forums/tag/{tag}', [
  'controller' => 'forums',
  'action' => 'board'
]);

$router->add('/forums/{tag}/@{author}/{permlink}', [
  'controller' => 'forums',
  'action' => 'view'
]);

return $router;
