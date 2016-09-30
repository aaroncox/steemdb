<?php
namespace SteemDB\Helpers;

use Phalcon\Tag;
class Markdown
{

  static public function string($string)
  {
    // Remove any body tags, because it seems to break the purifier
    $string = strip_tags($string, "<div><iframe><del><a><p><b><q><br><ul><li><ol><img><h1><h2><h3><h4><h5><h6><hr><blockquote><pre><code><em><strong><center><table><thead><tbody><tr><th><td><strike><sup>");
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
