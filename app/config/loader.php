<?php

use Phalcon\Loader;

$loader = new Loader();

$loader->registerNamespaces([
    'BexNetwork\Models'      => $config->application->modelsDir,
    'BexNetwork\Controllers' => $config->application->controllersDir,
    'BexNetwork\Helpers'     => $config->application->helpersDir,
    'BexNetwork'             => $config->application->libraryDir
]);

$loader->registerDirs(array(
    '../app/helpers'
));

$loader->register();

// Use composer autoloader to load vendor classes
require_once BASE_PATH . '/vendor/autoload.php';
