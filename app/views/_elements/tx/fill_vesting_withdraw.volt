<span class="ui left labeled button" tabindex="0">
  <span class="ui black right pointing label">
    Power Down
  </span>
  <span class="ui grey right pointing label">
    {{ item[1]['op'][1]['withdrawn'] }}
  </span>
  <a class="ui button">
    ~<?php echo $this->convert::vest2sp($item[1]['op'][1]['withdrawn']); ?>*
  </a>
</span>
<br>
from
<a href="/@{{ item[1]['op'][1]['from_account'] }}">
  {{ item[1]['op'][1]['from_account'] }}
</a>
to
<a href="/@{{ item[1]['op'][1]['to_account'] }}">
  {{ item[1]['op'][1]['to_account'] }}
</a>
