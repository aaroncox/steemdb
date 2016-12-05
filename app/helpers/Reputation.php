<?php
namespace SteemDB\Helpers;

use Phalcon\Tag;

class Reputation extends Tag
{
  static public function number($rep)
  {
    return (int)( is_numeric($rep) ? max( log10(abs($rep)) - 9, 0) * (($rep >= 0) ? 1 : -1) * 9 + 25 : 0 );
  }
}
