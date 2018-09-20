<?php

use MongoDB\BSON\UTCDateTime;
use SteemDB\Models\AuthorReward;
use SteemDB\Models\CurationReward;

class Utilities
{

  public function __construct($di) {
    $this->di = $di;
  }

  public function distribution($props) {
    $cacheKey = 'distribution-30d';
    $cached = $this->di->get('memcached')->get($cacheKey);
    if($cached !== null) {
      return $cached;
    }
    $totals = [
      'curation' => 0,
      'authors' => 0,
      'interest' => $this->di->get('convert')->sp2vest($props['virtual_supply'] * 0.095 * 0.15 / 12, false),
      'witnesses' => $this->di->get('convert')->sp2vest($props['virtual_supply'] * 0.095 * 0.1 / 12, false),
    ];
    // Set Date Range
    $start = new UTCDateTime(strtotime("-30 days") * 1000);
    $end = new UTCDateTime(strtotime("midnight") * 1000);
    // Author Rewards
    // Author Rewards
    $authors = AuthorReward::aggregate([
      ['$match' => [
        '_ts' => [
          '$gte' => $start,
          '$lte' => $end,
        ]
      ]],
      ['$project' => [
        'prefix' => ['$substr' => ['$permlink', 0, 3]],
        'steem_payout' => '$steem_payout',
        'vesting_payout' => '$vesting_payout',
        'sbd_payout' => '$sbd_payout',
      ]],
      ['$group' => [
        '_id' => 'author',
        'steem' => ['$sum' => '$steem_payout'],
        'vests' => ['$sum' => '$vesting_payout'],
        'sbd' => ['$sum' => 'sbd_payout'],
        'op' => [
          '$sum' => ['$cond' => [
            ['$eq' => ['$prefix', 're-']],
            0,
            '$vesting_payout',
          ]],
        ],
        're' => [
          '$sum' => ['$cond' => [
            ['$eq' => ['$prefix', 're-']],
            '$vesting_payout',
            0,
          ]],
        ]
      ]],
      // ['$sort' => [
      //   'vests' => -1
      // ]],
    ])->toArray();
    $totals['authors'] = $authors[0]['vests'] * 2;
    $totals['author_rewards'] = array(
      'replies' => $authors[0]['re'] * 2,
      'posts' => $authors[0]['op'] * 2,
    );
    // Curator Rewards
    $curators = CurationReward::aggregate([
      ['$match' => [
        '_ts' => [
          '$gte' => $start,
          '$lte' => $end,
        ]
      ]],
      ['$group' => [
        '_id' => '$curator',
        'vests' => ['$sum' => '$reward'],
      ]],
      ['$sort' => [
        'vests' => -1
      ]],
    ])->toArray();
    foreach($curators as $curator) {
      $totals['curation'] += $curator['vests'];
    }
    $this->di->get('memcached')->save($cacheKey, $totals, 60);
    return $totals;
  }

}
