<span class="ui mini left labeled button" tabindex="0">
  <a href="/@{{ item[1]['op'][1]['voter'] }}" class="ui {{ (item[1]['op'][1]['voter'] == account.name) ? 'grey' : ''}} right pointing label">
    {{ item[1]['op'][1]['voter'] }}
    ({{ item[1]['op'][1]['weight'] / 100 }}%)
  </a>
  <a href="/@{{ item[1]['op'][1]['author'] }}" class="ui {{ (item[1]['op'][1]['author'] == account.name) ? 'grey' : ''}} right pointing label">
    {{ item[1]['op'][1]['author'] }}
  </a>
  <a class="ui mini basic button" href="/tag/@{{ item[1]['op'][1]['author'] }}/{{ item[1]['op'][1]['permlink'] }}">
    <?= substr($item[1]['op'][1]['permlink'], 0, 75) ?>
  </a>
</span>
