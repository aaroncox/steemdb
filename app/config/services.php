<?php
use Phalcon\Mvc\View;
use Phalcon\Crypt;
use Phalcon\Mvc\Dispatcher;
use Phalcon\Mvc\Url as UrlResolver;
use Phalcon\Db\Adapter\Pdo\Mysql as DbAdapter;
use Phalcon\Mvc\View\Engine\Volt as VoltEngine;
use Phalcon\Mvc\Model\Metadata\Files as MetaDataAdapter;
use Phalcon\Session\Adapter\Files as SessionAdapter;
use Phalcon\Flash\Direct as Flash;
use Phalcon\Logger\Adapter\File as FileLogger;
use Phalcon\Logger\Formatter\Line as FormatterLine;
use Phalcon\Mvc\Collection\Manager;
use Phalcon\Db\Adapter\MongoDB\Client;

/**
 * Register the global configuration as config
 */
$di->setShared('config', function () {
    return include APP_PATH . "/config/config.php";
});

/**
 * The URL component is used to generate all kind of urls in the application
 */
$di->setShared('url', function () {
    $config = $this->getConfig();
    $url = new UrlResolver();
    $url->setBaseUri($config->application->baseUri);
    return $url;
});

/**
 * Setting up the view component
 */
$di->set('view', function () {
    $config = $this->getConfig();

    $view = new View();

    $view->setViewsDir($config->application->viewsDir);

    $view->registerEngines([
      '.volt' => function ($view) {
        $config = $this->getConfig();
        $volt = new VoltEngine($view, $this);
        $volt->setOptions([
          'compileAlways' => true,
          'compiledPath' => $config->application->cacheDir . 'volt/',
          'compiledSeparator' => '_'
        ]);
        $compiler = $volt->getCompiler();
        $compiler->addFunction(
          'markdown',
          function ($resolvedArgs, $exprArgs) {
            return 'SteemDB\Helpers\Markdown::string(' . $resolvedArgs . ')';
          }
        );
        return $volt;
      }
    ]);

    return $view;
}, true);

/**
 * Database connection is created based in the parameters defined in the configuration file
 */
$di->setShared('mongo', function () {
  $config = $this->getConfig();
  $mongo = new Client($config->database->host);
  $options = [];
  return $mongo->selectDatabase($config->database->dbname, $options);
});

// Collection Manager is required for MongoDB
$di->setShared('collectionManager', function () {
  $manager = new Manager();
  return $manager;
});

/**
 * If the configuration specify the use of metadata adapter use it or use memory otherwise
 */
$di->set('modelsMetadata', function () {
  $config = $this->getConfig();
  return new MetaDataAdapter([
    'metaDataDir' => $config->application->cacheDir . 'metaData/'
  ]);
});

/**
 * Start the session the first time some component request the session service
 */
$di->set('session', function () {
    $session = new SessionAdapter();
    $session->start();
    return $session;
});

/**
 * Crypt service
 */
$di->set('crypt', function () {
    $config = $this->getConfig();
    $crypt = new Crypt();
    $crypt->setKey($config->application->cryptSalt);
    return $crypt;
});

/**
 * Dispatcher use a default namespace
 */
$di->set('dispatcher', function () {
    $dispatcher = new Dispatcher();
    $dispatcher->setDefaultNamespace('SteemDB\Controllers');
    return $dispatcher;
});

/**
 * Loading routes from the routes.php file
 */
$di->set('router', function () {
    return require APP_PATH . '/config/routes.php';
});

/**
 * Logger service
 */
$di->set('logger', function ($filename = null, $format = null) {
  $config = $this->getConfig();

  $format   = $format ?: $config->get('logger')->format;
  $filename = trim($filename ?: $config->get('logger')->filename, '\\/');
  $path     = rtrim($config->get('logger')->path, '\\/') . DIRECTORY_SEPARATOR;

  $formatter = new FormatterLine($format, $config->get('logger')->date);
  $logger    = new FileLogger($path . $filename);

  $logger->setFormatter($formatter);
  $logger->setLogLevel($config->get('logger')->logLevel);

  return $logger;
});

$di->set('steemd', function() {
  require_once(APP_PATH . '/libs/steemd.php');
  return new Steemd('https://node.steem.ws');
});

$di->set('memcached', function() {
  $frontendOptions = array(
    'lifetime' => 60 * 5
  );
  $frontCache = new \Phalcon\Cache\Frontend\Data($frontendOptions);
  $backendOptions = array(
    "servers" => array(
      array(
        'host' => 'localhost',
        'port' => 11211,
        'weight' => 1
      ),
    )
  );
  $cache = new \Phalcon\Cache\Backend\Libmemcached($frontCache, $backendOptions);
  return $cache;
});

$di->set('convert', function () { return new SteemDB\Helpers\Convert(); });
$di->set('largeNumber', function () { return new SteemDB\Helpers\LargeNumber(); });
$di->set('reputation', function () { return new SteemDB\Helpers\Reputation(); });
$di->set('timeAgo', function () { return new SteemDB\Helpers\TimeAgo(); });
