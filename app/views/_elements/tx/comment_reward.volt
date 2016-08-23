<span class="ui blue label">
  +<?php echo $this->convert::vest2sp($item[1]['op'][1]['vesting_payout']); ?>
</span>
<span class="ui green label">
  +<?php echo $this->largeNumber::format($item[1]['op'][1]['sbd_payout']); ?>
  SBD
</span>
for
<a href="/tag/@{{ item[1]['op'][1]['author'] }}/{{ item[1]['op'][1]['permlink'] }}">
  <?= substr($item[1]['op'][1]['permlink'], 0, 75) ?>
</a>
