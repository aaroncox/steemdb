<?php
namespace SteemDB\Helpers;

use Phalcon\Tag;

class OpName extends Tag
{
  protected static $index = array(
    "account_create" => "Account Create",
    "account_update" => "Account Update",
    "account_witness_proxy" => "Witness Proxy",
    "account_witness_vote" => "Witness Vote",
    "comment" => "Post",
    "comment_reward" => "Post Reward",
    "convert" => "Convert",
    "curate_reward" => "Curate Reward",
    "feed_publish" => "Feed Publish",
    "fill_order" => "Fill Order",
    "fill_vesting_withdraw" => "Power Down",
    "interest" => "SBD Interest",
    "limit_order_create" => "Limit Order Create",
    "limit_order_cancel" => "Limit Order Cancel",
    "pow" => "Mining",
    "pow2" => "Mining",
    "transfer" => "Transfer",
    "transfer_to_vesting" => "Power Up",
    "vote" => "Vote",
    "witness_update" => "Witness Vote",
  );

  public static function string($op, $account) {
    $name = $op[0];
    if(isset(static::$index[$op[0]])) {
      $name = static::$index[$op[0]];
    }
    // This should be more robust logic as more situations occur
    if($op[0] === "comment" && $op[1]['author'] !== $account->name) {
      $name = "Reply";
    }
    return $name;
  }
}
