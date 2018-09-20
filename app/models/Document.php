<?php

namespace SteemDB\Models;

use Phalcon\Mvc\MongoCollection;

class Document extends MongoCollection
{

  protected static function _getResultset($params, $collection, $connection, $unique) {
    $results = parent::_getResultset($params, $collection, $connection, $unique);
    if(!$results) return $results;
    // Hacky way to force votes to have a timestamp
    // if($results->active_votes) {
    //   foreach($results->active_votes as $idx => $data) {
    //     $results->active_votes[$idx]->time = (int) (string) $data->time;
    //   }
    // }
    // if(is_array($results)) {
    //   foreach($results as $idx => $result) {
    //     foreach($result as $key => $data) {
    //       if(get_class($data) == 'MongoDB\BSON\UTCDateTime') {
    //         $results[$idx]->$key = (int) (string) $data;
    //       }
    //     }
    //   }
    // }
    return $results;
  }

  public function toArray() {
    if($this instanceOf Document) return parent::toArray();
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

  public static function agg($pipeline, $options = []) {
    $className = get_called_class();
    $collection = new $className();
    $connection = $collection->getConnection();
    return $connection->selectCollection($collection->getSource())->aggregate($pipeline, $options);
  }

}
