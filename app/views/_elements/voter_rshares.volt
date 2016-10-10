<div style="display: none">{{ voter.rshares }}</div>
<div class="ui <?php echo $this->largeNumber::color($voter->rshares / 1000)?> label" data-popup data-content="<?php echo number_format($voter->rshares, 3, ".", ",") ?> Reward Shares" data-variation="inverted" data-position="left center">
  <?php echo $this->largeNumber::format($voter->rshares, 'RS'); ?>
</div>
