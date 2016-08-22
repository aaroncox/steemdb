<a href="/@{{ item[1]['op'][1]['author'] }}" class="ui label">
  {{ item[1]['op'][1]['author'] }}
</a>
replied to
<a href="/tag/@{{ item[1]['op'][1]['parent_author'] }}/{{ item[1]['op'][1]['parent_permlink'] }}">
  <?= substr($item[1]['op'][1]['parent_permlink'], 0, 75) ?>
</a>
