<span class="ui left labeled button" tabindex="0">
  <a href="/@{{ item[1]['op'][1]['from'] }}" class="ui basic right pointing label">
    {{ item[1]['op'][1]['from'] }}
  </a>
  <a href="/@{{ item[1]['op'][1]['to'] }}" class="ui button">
    {{ item[1]['op'][1]['to'] }}
  </a>
</span>
<span class="ui green label">
  {{ item[1]['op'][1]['amount'] }}
</span>
{% if item[1]['op'][1]['memo'] %}
<div class="ui segment" style="max-width: 620px; overflow: scroll">
  {{ item[1]['op'][1]['memo'] }}
</div>
{% endif %}
