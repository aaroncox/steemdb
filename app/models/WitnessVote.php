<?php
namespace SteemDB\Models;

class WitnessVote extends Document
{
  public function getSource(){ return "witness_vote"; }
}
