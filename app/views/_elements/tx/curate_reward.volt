<span class="ui blue label">
  +<?php echo $this->convert::vest2sp($item[1]['op'][1]['reward']); ?>
</span>
for
<a href="/tag/@{{ item[1]['op'][1]['comment_author'] }}/{{ item[1]['op'][1]['comment_permlink'] }}">
  <?= substr($item[1]['op'][1]['comment_permlink'], 0, 75) ?>
</a>
