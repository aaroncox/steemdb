<?php
/*
 * Define custom routes. File gets included in the router service definition.
 */
$router = new Phalcon\Mvc\Router();

$router->add('/@([-a-z0-9.]+)', [
  'controller' => 'account',
  'action' => 'view',
  'account' => 1
])->setName("account-view");

$router->add('/@([-a-z0-9.]+)/([-a-z0-9]+)', [
  'controller' => 'account',
  'account' => 1,
  'action' => 2
])->setName("account-view-section");

$router->add('/block/([a-z0-9]+)', [
  'controller' => 'block',
  'action' => 'view',
  'height' => 1
])->setName("block-view");


$router->add('/{tag}/@{author}/{permlink}', [
  'controller' => 'comment',
  'action' => 'view'
]);

$router->add('/accounts[/]?{filter}?', [
  'controller' => 'accounts',
  'action' => 'list'
]);

$router->add('/powerup', [
  'controller' => 'labs',
  'action' => 'powerup'
]);


$router->add('/posts', [
  'controller' => 'comment',
  'action' => 'list'
]);

$router->add('/', [
  'controller' => 'comment',
  'action' => 'daily'
]);

$router->add('/posts/{tag}/{sort}/{date}', [
  'controller' => 'comment',
  'action' => 'daily'
]);

$router->add('/witnesses', [
  'controller' => 'witness',
  'action' => 'list'
]);

$router->add('/witnesses/history', [
  'controller' => 'witness',
  'action' => 'history'
]);

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

// $router->add('/api/mining/{account}', [
//   'controller' => 'api',
//   'action' => 'mining'
// ]);

// $router->add('/api/history/{account}', [
//   'controller' => 'api',
//   'action' => 'history'
// ]);

return $router;
