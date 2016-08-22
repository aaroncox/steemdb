<?php
namespace SteemDB\Models;

class AccountHistory extends Document
{
  public function getSource(){ return "account_history"; }
}
