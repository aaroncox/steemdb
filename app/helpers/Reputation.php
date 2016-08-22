<?php
namespace SteemDB\Helpers;

use Phalcon\Tag;

class Reputation extends Tag
{


    static public function log10($rep) {
      $leadingDigits = (int) substr($rep, 0, 4);
      $log = log($leadingDigits) / log(10);
      $n = strlen($rep) - 1;
      return $n + ($log - (int) $log);
    }

    static public function repLog10($rep) {
      $rep = "" . $rep;
      $neg = (substr($rep, 0, 1) === '-');
      $rep = $neg ? substr($rep, 1) : $rep;
      $out = static::log10($rep);
      if(!is_numeric($out)) {
        $out = 0;
      }
      $out = max($out - 9, 0);
      $out = ($neg ? -1 : 1) * $out;
      $out = $out * 9 + 25;
      return (int) $out;
    }

    static public function number($rep)
    {
      return static::repLog10($rep);
    }
}
