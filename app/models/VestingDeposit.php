<?php
namespace SteemDB\Models;

class VestingDeposit extends Document
{
  public function getSource(){ return "vesting_deposit"; }
}
