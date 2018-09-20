<?php
namespace SteemDB\Controllers;

class RwController extends ControllerBase
{

  public function curationAction()
  {
    $rewards = CurationReward::agg([
      ['$match' => [
        'curator' => 'randowhale'
      ]],
      ['$sort' => [
        '_ts' => -1
      ]],
      ['$group' => [
        '_id' => [
          'doy' => ['$dayOfYear' => '$_ts'],
          'year' => ['$year' => '$_ts'],
          'month' => ['$month' => '$_ts'],
          'day' => ['$dayOfMonth' => '$_ts'],
          'dow' => ['$dayOfWeek' => '$_ts'],
        ],
        'reward' => ['$sum' => '$reward'],
        'count' => ['$sum' => 1]
      ]],
      ['$sort' => [
        '_id.year' => 1,
        '_id.doy' => 1,
        'reward' => -1
      ]],
      ['$limit' => 10]
    ])->toArray();
    var_dump($rewards); exit;
  }

}
