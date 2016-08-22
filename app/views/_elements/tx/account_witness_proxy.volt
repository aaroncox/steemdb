<span class="ui left labeled button" tabindex="0">
  <a href="/@{{ item[1]['op'][1]['account'] }}" class="ui basic right pointing label">
    {{ item[1]['op'][1]['account'] }}
  </a>
  <a href="/@{{ item[1]['op'][1]['proxy'] }}" class="ui button">
    {{ item[1]['op'][1]['proxy'] }}
  </a>
</span>
Witness voting power proxied from
{{ item[1]['op'][1]['account'] }}
to
{{ item[1]['op'][1]['proxy'] }}
