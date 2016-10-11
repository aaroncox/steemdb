<?php
namespace SteemDB\Helpers;

use Phalcon\Tag;

class Reputation extends Tag
{
    static public function number($rep)
    {
      return (int)( is_numeric($rep) ? max( log10(abs($rep)) - 9, 0) * gmp_sign($rep) * 9 + 25 : 0 );
    }
}
