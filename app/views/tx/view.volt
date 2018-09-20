{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui hidden divider"></div>
<div class="ui container">
  <div class="ui vertically divided grid">
    <div class="row">
      <div class="column">
        <div class="ui large header">
          Transaction {{ id }}
        </div>
      </div>
    </div>
    {% if current %}
    <div class="row">
      <div class="column">
        <div class="ui bottom attached padded segment">
          {% include '_elements/definition_table' with ['data': current] %}
        </div>
      </div>
    </div>
    {% else %}
    <div class="row">
      <div class="column">
        <div class="ui very padded center aligned segment">
          <div class="ui header">This block has not yet been imported into SteemDB. Refresh the page to try again.</div>
          <a href="/block/{{ height }}" class="ui primary button">Reload Page</a>
        </div>
      </div>
    </div>
    {% endif %}
  </div>
</div>
{% endblock %}

{% block scripts %}
  {% if chart is defined %}
    {% include 'charts/account/' ~ router.getActionName() %}
  {% endif %}
  <script>
    $('.tabular.menu .item')
      .tab({

      });
  </script>
{% endblock %}
