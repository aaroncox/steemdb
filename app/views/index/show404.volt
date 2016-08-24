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
      <div class="column">
        <div class="ui large header">
          Page Not Found
        </div>
        The page you're requesting could not be loaded.
      </div>
    </div>
  </div>
</div>
{% endblock %}

{% block scripts %}
{% endblock %}
