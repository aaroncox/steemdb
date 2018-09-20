<?php

use Phalcon\DI\FactoryDefault;
use Phalcon\Mvc\Application;

// error_reporting(E_ALL);
error_reporting(E_ERROR | E_PARSE);

/**
 * Define some useful constants
 */
define('BASE_PATH', dirname(__DIR__));
define('APP_PATH', BASE_PATH . '/app');

try {

    /**
     * The FactoryDefault Dependency Injector automatically register the right services providing a full stack framework
     */
    $di = new FactoryDefault();

    /**
     * Read services
     */
    include APP_PATH . "/config/services.php";

    /**
     * Get config service for use in inline setup below
     */
    $config = $di->getConfig();

    /**
     * Include Autoloader
     */
    include APP_PATH . '/config/loader.php';

    /**
    * Handle the request
    */
    $application = new Application($di);

    echo $application->handle()
        ->getContent();

} catch (Exception $e) {
    echo $e->getMessage(), '<br>';
    echo nl2br(htmlentities($e->getTraceAsString()));
}

// use Phalcon\Loader;
// use Phalcon\Mvc\View;
// use Phalcon\Mvc\Application;
// use Phalcon\Di\FactoryDefault;
// use Phalcon\Mvc\Url as UrlProvider;
// use Phalcon\Mvc\Collection\Manager;
// use Phalcon\Db\Adapter\MongoDB\Client;

// try {

//     require '../vendor/autoload.php';

//     // Register an autoloader
//     $loader = new Loader();
//     $loader->registerDirs(array(
//         '../app/controllers/',
//         '../app/models/'
//     ))->register();

//     // Create a DI
//     $di = new FactoryDefault();

//     // Setup the view component
//     $di->set('view', function () {
//         $view = new View();
//         $view->setViewsDir('../app/views/');
//         return $view;
//     });

//     // Initialise the mongo DB connection.
//     $di->setShared('mongo', function () {
//         $mongo = new Client("mongodb://mongo:27017");
//         $options = [
//             'typeMap' => [
//                 'root' => 'array',
//                 'document' => 'object',
//                 'array' => 'array'
//             ]
//         ];
//         return $mongo->selectDatabase('steemdb', $options);
//     });

//     // Collection Manager is required for MongoDB
//     $di->setShared('collectionManager', function () {
//         return new Manager();
//     });

//     // Setup a base URI so that all generated URIs include the "tutorial" folder
//     $di->set('url', function () {
//         $url = new UrlProvider();
//         $url->setBaseUri('/tutorial/');
//         return $url;
//     });

//     $application = new Application($di);

//     // Handle the request
//     $response = $application->handle();

//     $response->send();

// } catch (\Exception $e) {
//      echo "Exception: ", $e->getMessage();
// }
