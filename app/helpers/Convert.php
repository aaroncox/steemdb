<?php
namespace BexNetwork\Helpers;

use Phalcon\Tag;

class Convert extends Tag
{

  static private function getCache() {
    return static::getDI()->getShared('memcached');
  }

  static private function getProps() {
    return static::getDI()->getShared('dpayd')->getProps();
  }

  static public function getConversionRate($key) {
    $cache = static::getCache();
    $cached = $cache->get($key);
    if($cached === null) {
      $props = static::getProps();
      $values = array(
        'total_vests' => (float) $props['total_vesting_shares'],
        'total_vest_dpay' => (float) $props['total_vesting_fund_dpay'],
      );
      $cache->save($key, $values);
      return $values;
    }
    return $cached;
  }

  static public function vest2sp($value, $label = ' BP', $round = 3)
  {
    $values = static::getConversionRate('convert_vest2sp');
    $return = $values['total_vest_dpay'] * ($value / $values['total_vests']);
    if($label === false) {
      return round($return, $round);
    }
    return number_format($return, $round, '.', ',') . $label;
  }

  static public function sp2vest($value, $label = ' VEST')
  {
    $values = static::getConversionRate('convert_vest2sp');
    return number_format((($value * 1000) / $values['total_vest_dpay']) * $values['total_vests'], 3, '.', ',') . $label;
  }
}
