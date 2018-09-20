<?php
namespace SteemDB\Models;

use MongoDB\BSON\UTCDateTime;

class Comment extends Document
{

  public function metadata($key = null) {
    // Return an empty array if we have nothing
    if(!$this->json_metadata) return [];
    // If we have an object with data, use that
    if(!is_string($this->json_metadata)) {
      if($key && isset($this->json_metadata->$key)) {
        return $this->json_metadata->$key;
      }
      return $this->json_metadata;
    }
    // If we have a string of json, decode and return
    $metadata = json_decode($this->json_metadata, true);
    if($key) {
      if(isset($metadata[$key])) {
        $metadata = $metadata[$key];
      } else {
        return null;
      }
    }
    return $metadata;
  }

  public function origin() {
    $app = $this->metadata('app');
    if(!is_string($app)) return null;
    $parts = explode("/", $app);
    if(sizeof($parts) > 1) {
      return $parts[0];
    }
    return $app;
  }

  public function getChildren() {
    $query = array(
      'parent_permlink' => $this->permlink
    );
    return Comment::find(array(
      $query
    ));
  }

  public static function rsharesAllocation($dates = []) {
    ini_set('precision',20);
    if(!is_array($dates) || !count($dates)) {
      $dates = [
        '$gte' => new UTCDateTime(strtotime("-30 days") * 1000),
        '$lte' => new UTCDateTime(strtotime("midnight") * 1000),
      ];
    }
    $results = Comment::agg([
      [
        '$match' => [
          'created' => $dates
        ]
      ],
      [
        '$project' => [
          'author' => 1,
          'active_votes' => 1,
          'created' => 1
        ]
      ],
      [
        '$unwind' => '$active_votes'
      ],
      [
        '$match' => [
          'active_votes.weight' => ['$ne' => 0]
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'voter' => '$active_votes.voter',
            'doy' => ['$dayOfYear' => '$created'],
            'year' => ['$year' => '$created'],
            'month' => ['$month' => '$created'],
            'day' => ['$dayOfMonth' => '$created'],
          ],
          'votes' => [
            '$sum' => 1
          ],
          'rshares' => [
            '$sum' => '$active_votes.rshares'
          ]
        ]
      ],
      [
        '$sort' => [
          'rshares' => -1
        ]
      ],
      [
        '$group' => [
          '_id' => [
            'doy' => '$_id.doy',
            'year' => '$_id.year',
            'month' => '$_id.month',
            'day' => '$_id.day',
          ],
          'total_voters' => [
            '$sum' => 1
          ],
          'total_rshares' => [
            '$sum' =>'$rshares'
          ],
          'voters' => [
            '$push' => [
              'voter' => '$_id.voter',
              'votes' => '$votes',
              'rshares' => '$rshares',
            ]
          ]
        ]
      ],
      [
        '$project' => [
          '_id' => '$_id',
          'total_voters' => '$total_voters',
          'total_rshares' => '$total_rshares',
          'voters' => [
            '$slice' => [
              '$voters', 100
            ]
          ]
        ]
      ],
      [
        '$unwind' => '$voters'
      ],
      [
        '$lookup' => [
          'from' => 'account',
          'localField' => 'voters.voter',
          'foreignField' => 'name',
          'as' => 'account'
        ]
      ],
      [
        '$sort' => [
          '_id.year' => 1,
          '_id.doy' => 1
        ]
      ]
      // [
      //   '$limit' => 10
      // ]
    ], [
      'allowDiskUse' => true,
      'cursor' => [
        'batchSize' => 0
      ]
    ]);
    // var_dump($results->toArray()[0]['account'][0]); exit;
    return $results;
  }
}
