<?php
namespace SteemDB\Models;

class VestingWithdraw extends Document
{
  public function getSource(){ return "vesting_withdraw"; }
}
