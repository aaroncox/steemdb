<?php
/*
 * Define custom routes. File gets included in the router service definition.
 */
$router = new Phalcon\Mvc\Router();

$router->add('/@{account}', [
  'controller' => 'account',
  'action' => 'view'
]);

$router->add('/{tag}/@{author}/{permlink}', [
  'controller' => 'comment',
  'action' => 'view'
]);

$router->add('/accounts[/]?{filter}?', [
  'controller' => 'account',
  'action' => 'list'
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

$router->add('/api/tags/{tag}', [
  'controller' => 'api',
  'action' => 'tags'
]);

$router->add('/api/account/{account}/{action}', [
  'controller' => 'account_api',
  'action' => 'test'
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
