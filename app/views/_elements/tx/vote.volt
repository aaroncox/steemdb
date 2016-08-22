<a href="/@{{ item[1]['op'][1]['voter'] }}" class="ui label">
  {{ item[1]['op'][1]['voter'] }}
  ({{ item[1]['op'][1]['weight'] / 100 }}%)
</a>
on
<a href="/tag/@{{ item[1]['op'][1]['author'] }}/{{ item[1]['op'][1]['permlink'] }}">
  <?= substr($item[1]['op'][1]['permlink'], 0, 75) ?>
</a>
