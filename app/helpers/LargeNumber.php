<?php
namespace SteemDB\Helpers;

use Phalcon\Tag;

class LargeNumber extends Tag
{

    static public function format($n)
    {
        if($n>1000000000000000) return round(($n/1000000000000000),3).'q';
        else if($n>1000000000000) return round(($n/1000000000000),3).'t';
        else if($n>1000000000) return round(($n/1000000000),3).'b';
        else if($n>1000000) return round(($n/1000000),3).'m';
        else if($n>1000) return round(($n/1000),3).'k';
        return round($n, 3);
    }
}
