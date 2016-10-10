<div style="display: none"><?php echo number_format($voter->weight, 0, "", "") ?></div>
<div class="ui <?php echo $this->largeNumber::color($voter->weight / 1000000)?> label" data-popup data-content="<?php echo number_format($voter->weight, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
  <?php echo $this->largeNumber::format($voter->weight); ?>
</div>
