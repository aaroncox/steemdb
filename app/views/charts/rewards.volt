{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<style>
  .tooltip {
  /* keep tooltips from blocking interactions */
  pointer-events: none;
}
</style>
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="center aligned column">
        <div class="ui segment">
          <svg width="100%" height="500px" id="rewards"></svg>
        </div>
      </div>
    </div>
  </div>
</div>

{% endblock %}

{% block scripts %}
  {% include 'charts/chart/rewards.volt' %}
{% endblock %}
