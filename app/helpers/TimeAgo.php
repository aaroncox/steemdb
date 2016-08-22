<?php
namespace SteemDB\Helpers;

use Phalcon\Tag;

class TimeAgo extends Tag
{

    public static function timestamp($datetime, $full = false) {
        $now = new \DateTime;
        $ago = new \DateTime();
        $ago->setTimestamp($datetime);
        $diff = $now->diff($ago);
        $diff->w = floor($diff->d / 7);
        $diff->d -= $diff->w * 7;

        $string = array(
            'y' => 'year',
            'm' => 'month',
            'w' => 'week',
            'd' => 'day',
            'h' => 'hour',
            'i' => 'minute',
            's' => 'second',
        );
        foreach ($string as $k => &$v) {
            if ($diff->$k) {
                $v = $diff->$k . ' ' . $v . ($diff->$k > 1 ? 's' : '');
            } else {
                unset($string[$k]);
            }
        }
        if (!$full) $string = array_slice($string, 0, 1);
        return $string ? implode(', ', $string) . (($diff->invert) ? ' ago' : '') : 'just now';
    }

    public static function mongo($mongodate) {
      return self::timestamp((string) $mongodate / 1000);
    }

    public static function string($string) {
      return self::timestamp(strtotime($string));
    }

    public function secondsToString($seconds, $full = false) {
        $now = new DateTime;
        $future = new DateTime();
        $future->setTimestamp(time() + $seconds);
        $diff = $now->diff($future);

        $diff->w = floor($diff->d / 7);
        $diff->d -= $diff->w * 7;

        $string = array(
            'y' => 'year',
            'm' => 'month',
            'w' => 'week',
            'd' => 'day',
            'h' => 'hour',
            'i' => 'minute',
            's' => 'second',
        );
        foreach ($string as $k => &$v) {
            if ($diff->$k) {
                $v = $diff->$k . ' ' . $v . ($diff->$k > 1 ? 's' : '');
            } else {
                unset($string[$k]);
            }
        }

        if (!$full) $string = array_slice($string, 0, 1);
        return $string ? implode(', ', $string) : '';
    }

    public static function age($age) {
        $i = time() - $age;
        $m = time()-$i; $o='just now';
        $t = array('year'=>31556926,'month'=>2629744,'week'=>604800,'day'=>86400,'hour'=>3600,'minute'=>60,'second'=>1);
        foreach($t as $u=>$s){
          if($s<=$m){$v=floor($m/$s); $o="$v $u".($v==1?'':'s'); break;}
        }
        return $o;
    }
}
