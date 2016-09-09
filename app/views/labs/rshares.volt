{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}

<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui top attached menu">
          <a href="/labs/rshares?date={{ date('Y-m-d', date - 86400)}}" class="item">
            <i class="left arrow icon"></i>
            <span class="mobile hidden">{{ date('Y-m-d', date - 86400)}}</span>
          </a>
          <div class="right menu">
            <?php if($date > time() - 86400): ?>
            <a class="disabled item">
              <span class="mobile hidden">{{ date('Y-m-d', date + 86400)}}</span>
              <i class="right arrow icon"></i>
            </a>
            <?php else: ?>
            <a href="/labs/rshares?date={{ date('Y-m-d', date + 86400)}}" class="item">
              <span class="mobile hidden">{{ date('Y-m-d', date + 86400)}}</span>
              <i class="right arrow icon"></i>
            </a>
            <?php endif ?>
          </div>
        </div>
        {% for day in data %}
        <div class="ui segment">
          <div class="ui large header">
            Day of {{ day['_id']['year'] }}-{{ day['_id']['month'] }}-{{ day['_id']['day'] }}
            <div class="sub header">

            </div>
          </div>
          <div class="ui small statistics">
            <div class="statistic">
              <div class="value">
                {{ day.total_rshares }}
              </div>
              <div class="label">Total Reward Shares</div>
            </div>
            <div class="statistic">
              <div class="value">
                {{ day.total_voters }}
              </div>
              <div class="label">Voters</div>
            </div>
          </div>
          <table class="ui table">
            <thead>
              <tr>
                <th class="collapsing">#</th>
                <th class="collapsing">%</th>
                <th class="collapsing">Total Reward Shares</th>
                <th class="collapsing">Total Votes</th>
                <th>Account</th>
              </tr>
            </thead>
            <tbody></tbody>
          {% for idx, voter in day['voters'] %}
            <tr>
              <td>
                #{{ idx + 1 }}
              </td>
              <td>
                <?php echo number_format(($voter['rshares'] / $day['total_rshares']) * 100, 2) ?>%
              </td>
              <td class="right aligned">
                {{ voter.rshares }}
              </td>
              <td>
                {{ voter.votes }}
              </td>
              <td>
                <a href="/@{{ voter.voter }}">
                  {{ voter.voter }}
                </a>
              </td>
            </tr>
          {% endfor %}
          </table>
        </div>
        {% else %}
        <div class="ui message">
          No data for this date
        </div>
        {% endfor %}
      </div>
    </div>
  </div>
</div>

{% endblock %}

{% block scripts %}

{% endblock %}
