{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui large header">
          Account List by Flags Received
          <div class="sub header">
            Displaying the top 200 most-flagged accounts
          </div>
        </div>
        <table class="ui table">
          <thead>
            <tr>
              <th>Account</th>
              <th>Total Flags</th>
              <th>Posts Flagged</th>
              <th>Prominent Flaggers</th>
            </tr>
          </thead>
          <tbody>
            {% for account in accounts %}
            <tr>
              <td>
                <a href="/@{{ account['_id'] }}">
                  {{ account['_id'] }}
                </a>
              </td>
              <td>
                {{ account['count'] }}
              </td>
              <td>
                {{ account['posts'] | length }}
              </td>
              <td class="ten wide">
                {% for voter, count in account['voters'] %}
                  <a href="/@{{ voter }}">{{ voter }}</a> ({{ count }}){% if not loop.last %},{% endif %}
                {% endfor %}
              </td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

{% endblock %}

{% block scripts %}

{% endblock %}
