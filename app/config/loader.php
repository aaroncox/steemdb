<?php

use Phalcon\Loader;

$loader = new Loader();

$loader->registerNamespaces([
    'SteemDB\Models'      => $config->application->modelsDir,
    'SteemDB\Controllers' => $config->application->controllersDir,
    'SteemDB\Helpers'     => $config->application->helpersDir,
    'SteemDB'             => $config->application->libraryDir
]);

$loader->registerDirs(array(
    '../app/helpers'
));

$loader->register();

// Use composer autoloader to load vendor classes
require_once BASE_PATH . '/vendor/autoload.php';
