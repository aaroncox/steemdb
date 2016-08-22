<?php
namespace SteemDB\Helpers;

use Phalcon\Tag;
class Markdown
{

  static public function string($string)
  {
    // Let's turn image URLs into <img> tags
    $regex = "~<img[^>]*>(*SKIP)(*FAIL)|\\[[^\\]]*\\](*SKIP)(*FAIL)|\\([^\\)]*\\)(*SKIP)(*FAIL)|https?://[^/\\s]+/\\S+\\.(?:jpg|png|gif)~i";
    $string = preg_replace($regex, '<img src="${0}">', $string);
    // Then let's parse the markdown
    $string = \Michelf\Markdown::defaultTransform($string);
    // Now clean it
    $purifier = new \HTMLPurifier();
    $string = $purifier->purify($string);
    return $string;
  }


}
