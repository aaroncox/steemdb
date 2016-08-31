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
          <svg width="100%" height="500px" id="supply"></svg>
        </div>
        <div class="ui segment">
          <svg width="100%" height="500px" id="activity"></svg>
        </div>
        <div class="ui segment">
          <svg width="100%" height="500px" id="authors"></svg>
        </div>
        <div class="ui segment">
          <svg width="100%" height="500px" id="votes"></svg>
        </div>
        <div class="ui segment">
          <svg width="100%" height="500px" id="growth"></svg>
        </div>
      </div>
    </div>
  </div>
</div>
{#
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="center aligned column">
        <table class="ui table">
          <thead>
            <tr>
              <th>Account</th>
              <th>Vesting</th>
            </tr>
          </thead>
          <tbody>
            {% for account in accounts %}
            <tr>
              <td>
                {{ link_to("/@" ~ account.name, account.name) }}
              </td>
              <td>{{ account.vesting_shares }}</td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
#}

{% endblock %}

{% block scripts %}
  {% include 'charts/supply.volt' %}
  {% include 'charts/activity.volt' %}
  {% include 'charts/growth.volt' %}
  {% include 'charts/authors.volt' %}
  {% include 'charts/votes.volt' %}
{% endblock %}
