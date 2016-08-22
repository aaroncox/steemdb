<span class="ui left labeled button" tabindex="0">
  {% if item[1]['op'][1]['approve'] %}
  <span class="ui purple right pointing label">
    Approval of
  </span>
  {% else %}
  <span class="ui orange right pointing label">
    Unapproved
  </span>
  {% endif %}
  <a href="/@{{ item[1]['op'][1]['witness'] }}" class="ui button">
    {{ item[1]['op'][1]['witness'] }}
  </a>
</span>
from
<a href="/@{{ item[1]['op'][1]['account'] }}">
  {{ item[1]['op'][1]['account'] }}
</a>
