<div class="ui <?php echo $this->largeNumber::color($current->vesting_shares)?> label" data-popup data-content="<?php echo number_format($current->vesting_shares, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
  <?php echo $this->largeNumber::format($current->vesting_shares); ?>
</div>
