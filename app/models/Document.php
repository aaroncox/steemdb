<?php

namespace SteemDB\Models;

use Phalcon\Mvc\MongoCollection;

class Document extends MongoCollection
{

  public function toArray() {
    foreach($this as $key => $data) {
      if(get_class($data) == 'MongoDB\BSON\UTCDateTime') {
        $this->$key = (int) (string) $data;
      }
    }
    return parent::toArray();
  }

  public function export() {
    $toRemove = ['_dependencyInjector','_modelsManager','_source','_operationMade','_connection', '_errorMessages', '_skipped'];
    $data = array_diff_key(get_object_vars($this), array_flip($toRemove));
    return $data;
  }

  public static function aggregate($pipeline, $options = []) {
    $className = get_called_class();
    $collection = new $className();
    $connection = $collection->getConnection();
    return $connection->selectCollection($collection->getSource())->aggregate($pipeline, $options);
  }

}
