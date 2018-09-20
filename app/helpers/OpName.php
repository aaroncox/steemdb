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
    "author_reward" => "Author Reward",
    "cancel_transfer_from_savings" => "Cancel Savings Withdrawal",
    "comment" => "Post",
    "comment_reward" => "Post Reward",
    "convert" => "Convert",
    "curate_reward" => "Curate Reward",
    "curation_reward" => "Curation Reward",
    "delete_comment" => "Post Delete",
    "feed_publish" => "Feed Publish",
    "fill_order" => "Fill Order",
    "fill_vesting_withdraw" => "Power Down",
    "interest" => "SBD Interest",
    "limit_order_create" => "Limit Order Create",
    "limit_order_cancel" => "Limit Order Cancel",
    "pow" => "Mining",
    "pow2" => "Mining",
    "transfer" => "Transfer",
    "transfer_to_savings" => "Transfer to Savings",
    "transfer_from_savings" => "Transfer from Savings",
    "transfer_to_vesting" => "Power Up",
    "vote" => "Vote",
    "witness_update" => "Witness Update",
  );

  public static function string($op, $account = null) {
    $name = $op[0];
    if(isset(static::$index[$op[0]])) {
      $name = static::$index[$op[0]];
    }
    // This should be more robust logic as more situations occur
    if($op[0] === "vote" && $account) {
      if($op[1]['voter'] === $account->name) {
        $name = "Outgoing Vote";
      } else {
        $name = "Incoming Vote";
      }
    }
    if($op[0] === "comment" && is_array($op[1]) && $op[1]['author'] !== $account->name) {
      $name = "Reply";
    }
    return $name;
  }
}
