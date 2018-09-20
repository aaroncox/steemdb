{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui stackable grid container">
    <div class="row">
      <div class="twelve wide column" id="main-context">
        <div class="ui top attached menu">
          {{ link_to(["for": "app-view", "app": app], "<i class='home icon'></i>", "class": "icon item" ~ (router.getActionName() == "view" ? " active" : "")) }}
          {{ link_to(["for": "app-view-section", "app": app, "action": "earnings"], "Earnings", "class": "item" ~ (router.getActionName() == "earnings" ? " active" : "")) }}
        </div>
        <div class="ui bottom attached secondary segment">
          {% include "app/view/" ~ router.getActionName() %}
        </div>
      </div>
      <div class="four wide column">
        <div class="ui sticky">
          {% include '_elements/cards/app.volt' %}
        </div>
      </div>
    </div>
  </div>
</div>
{% endblock %}

{% block scripts %}
  {% if chart is defined %}
    {% include 'charts/account/' ~ router.getActionName() %}
  {% endif %}
  <script>
    $('.ui.indicating.progress')
      .progress({
        percent: {{ live[0]['voting_power'] / 100 }}
      });
    $('.tabular.menu .item')
      .tab({

      });
    $('.ui.sticky')
      .sticky({
        context: '#main-context',
        offset: 90
      });
    $(".ui.sortable.table").tablesort();
  </script>
{% endblock %}
