<?php
namespace SteemDB\Helpers;

use Phalcon\Tag;
use League\CommonMark\CommonMarkConverter;

class Markdown
{

  static public function string($string)
  {
    // Remove any body tags, because it seems to break the purifier
    $string = str_replace('<3', '&#60;3', $string);

    // Strip any disallowed tags
    $string = strip_tags($string, "<div><iframe><del><a><p><b><q><br><br/><ul><li><ol><img><h1><h2><h3><h4><h5><h6><hr><blockquote><pre><code><em><strong><center><table><thead><tbody><tr><th><td><strike><sup><sub>");

    // Let's turn image URLs into <img> tags
    $regex = "~<img[^>]*>(*SKIP)(*FAIL)|\\[[^\\]]*\\](*SKIP)(*FAIL)|\\([^\\)]*\\)(*SKIP)(*FAIL)|https?://[^/\\s]+/\\S+\\.(?:jpg|png|gif)((\?.*)$|$)~i";
    $string = preg_replace($regex, '<img src="${0}">', $string);

    // Linkify Links
    // $string = preg_replace('/(https?:\/\/\S+)/', '<a href="\1">\1</a>', $string);

    // Linkify usernames
    $string = preg_replace('/(^|\s)@((?:[^_\W]|-)+)/', '\1<a href="http://steemdb.com/@\2">@\2</a>', $string);

    // Linkify tags
    $string = preg_replace('/(^|\s)#(\w+)/', '\1<a href="/forums/tag/\2">#\2</a>', $string);

    // Embed Youtube Videos
    $string = preg_replace("/\s*[a-zA-Z\/\/:\.]*youtube.com\/watch\?v=([a-zA-Z0-9\-_]+)([a-zA-Z0-9\/\*\-\_\?\&\;\%\=\.]*)/i","\n\n<div class='ui embed' data-url='//www.youtube.com/embed/$1'></div>\n\n",$string);
    $string = preg_replace("/\s*[a-zA-Z\/\/:\.]*youtu.be\/([a-zA-Z0-9\-_]+)([a-zA-Z0-9\/\*\-\_\?\&\;\%\=\.]*)/i","\n\n<div class='ui embed' data-url='//www.youtube.com/embed/$1'></div>\n\n",$string);

    // Convert markdown
    $converter = new CommonMarkConverter();
    $string = $converter->convertToHtml($string);

    // Fix UTF-8 strings
    $string = mb_convert_encoding($string, "HTML-ENTITIES", "UTF-8");

    // Parse document for modification at the dom level
    $dom=new \DOMDocument();
    $dom->loadHTML($string);

    // Prefix all images with steemit's image processor
    foreach($dom->getElementsByTagName("img") as $img) {
      $original = $img->getAttribute("src");
      $img->setAttribute( "src" , "https://steemitimages.com/0x0/" . $original );
    }

    // Format all line breaks to semantic styling
    foreach($dom->getElementsByTagName("hr") as $img) {
      $img->setAttribute( "class" , "ui divider" );

    }
    // Add some semantic-ui classes to elements for formatting
    foreach($dom->getElementsByTagName("table") as $table) {
      $classes = $table->getAttribute("class");
      $table->setAttribute("class", $classes . " ui table");
    }

    // Re-export our dom
    $string = $dom->saveHtml();

    // Ensure we have our line breaks that are forced
    $string = nl2br($string);

    // Return content
    return $string;
  }

}
