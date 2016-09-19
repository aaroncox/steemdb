<?php
namespace SteemDB\Helpers;

use Phalcon\Tag;

class Convert extends Tag
{

  static private function getCache() {
    return static::getDI()->getShared('memcached');
  }

  static private function getProps() {
    return static::getDI()->getShared('steemd')->getProps();
  }

  static public function getConversionRate($key) {
    $cache = static::getCache();
    $cached = $cache->get($key);
    if($cached === null) {
      $props = static::getProps();
      $values = array(
        'total_vests' => (float) $props['total_vesting_shares'],
        'total_vest_steem' => (float) $props['total_vesting_fund_steem'],
      );
      $cache->save($key, $values);
      return $values;
    }
    return $cached;
  }

  static public function vest2sp($value, $label = ' SP')
  {
    $values = static::getConversionRate('convert_vest2sp');
    return number_format($values['total_vest_steem'] * ($value / $values['total_vests']), 3, '.', ',') . $label;
  }

  static public function sp2vest($value, $label = ' VEST')
  {
    $values = static::getConversionRate('convert_vest2sp');
    return number_format((($value * 1000) / $values['total_vest_steem']) * $values['total_vests'], 3, '.', ',') . $label;
  }
}
