<?php
namespace SteemDB\Models;

class CommentDiff extends Document
{
  public function getSource(){ return "comment_diff"; }
}
