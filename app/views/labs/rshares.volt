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
        {% if data %}
        <div class="ui segment">
          <div class="ui large header">
            Day of {{ data[0]['_id']['year'] }}-{{ data[0]['_id']['month'] }}-{{ data[0]['_id']['day'] }}
            <div class="sub header">

            </div>
          </div>
          <div class="ui small statistics">
            <div class="statistic">
              <div class="value">
                {{ data[0].total_rshares }}
              </div>
              <div class="label">Total Reward Shares</div>
            </div>
            <div class="statistic">
              <div class="value">
                {{ data[0].total_voters }}
              </div>
              <div class="label">Voters</div>
            </div>
            <div class="statistic">
              <div class="value">
                <?php echo number_format(($rshares / $data[0]->total_rshares) * 100, 3, ".", "") ?>%
              </div>
              <div class="label">Top 100 Percent of Total</div>
            </div>
            <div class="statistic">
              <div class="value">
                <?php echo $this->largeNumber::format($median); ?>
              </div>
              <div class="label">Median Account Size</div>
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
                <th>Vesting Shares</th>
              </tr>
            </thead>
            <tbody></tbody>
          {% for idx, voter in data %}
            <tr>
              <td>
                #{{ idx + 1 }}
              </td>
              <td>
                <?php echo number_format(($voter['voters']['rshares'] / $data[0]['total_rshares']) * 100, 2) ?>%
              </td>
              <td class="right aligned">
                {{ voter['voters'].rshares }}
              </td>
              <td>
                {{ voter['voters'].votes }}
              </td>
              <td>
                <a href="/@{{ voter['voters'].voter }}">
                  {{ voter['voters'].voter }}
                </a>
              </td>
              <td>
                {{ partial("_elements/vesting_shares", ['current': voter.account[0]]) }}
              </td>
            </tr>
          {% endfor %}
          </table>
        </div>
        {% else %}
        <div class="ui message">
          No data for this date
        </div>
        {% endif %}
      </div>
    </div>
  </div>
</div>

{% endblock %}

{% block scripts %}

{% endblock %}
