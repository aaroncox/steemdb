{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui large header">
          Steem Clients
          <div class="sub header">
            Usage of the various Steem clients
          </div>
        </div>
        <div class="ui grid">
          <div class="ui two column row">
            <div class="column">
              <div class="ui segment">
                <div class="ui header">
                  Top Platforms by Post (90 days)
                </div>
                <table class="ui small compact table">
                <thead>
                  <tr>
                    <th></th>
                    <th>Platform</th>
                    <th>Posts</th>
                    <th>%</th>
                  </tr>
                </thead>
                <tbody>
                  {% for platform, count in posts %}
                    <tr>
                      <td class='collapsing'>
                        {{ loop.index }}
                      </td>
                      <td>
                        {{ (platform) ? platform : 'unknown' }}
                      </td>
                      <td>
                        {{ count }}
                      </td>
                      <td>
                        <?php echo round($count / array_sum($posts) * 100, 2) ?>%
                      </td>
                    </tr>
                  {% endfor %}
                </tbody>
              </table>
              </div>
            </div>
            <div class="column">
              <div class="ui segment">
                <div class="ui header">
                  Top Platforms by Rewards Generated (90 days)
                </div>
                <table class="ui small compact table">
                  <thead>
                    <tr>
                      <th></th>
                      <th>Platform</th>
                      <th>Rewards</th>
                      <th>%</th>
                    </tr>
                  </thead>
                  <tbody>
                    {% for platform, amount in rewards %}
                      <tr>
                        <td class='collapsing'>
                          {{ loop.index }}
                        </td>
                        <td>
                          {{ (platform) ? platform : 'unknown' }}
                        </td>
                        <td>
                          {{ amount }}
                        </td>
                        <td>
                          <?php echo round($amount / array_sum($rewards) * 100, 2) ?>%
                        </td>
                      </tr>
                    {% endfor %}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <div class="ui divider"></div>
        <div class="ui header">
          Last 90 Days
          <div class="sub header">
            Individual date breakdown by platform
          </div>
        </div>
        <table class='ui table'>
          <thead>
            <tr>
              <th>Date</th>
              <th>Total Rewards</th>
              <th>Posts</th>
              <th>Clients</th>
            </tr>
          </thead>
          <tbody>
          {% for day in dates %}
            <tr>
              <td>
                {{ day._id.year }}-{{ day._id.month }}-{{ day._id.day }}
              </td>
              <td>
                ${{ day.reward }}
              </td>
              <td>
                {{ day.total }}
              </td>
              <td class='collapsing'>
                <table class="ui compact small table">
                  <thead>
                    <tr>
                      <th>Platform</th>
                      <th>Posts</th>
                      <th>Rewards</th>
                    </tr>
                  </thead>
                  <tbody>
                    {% for client in day.clients %}
                    <tr>
                      <td>
                        {{ (client.client) ? client.client : 'unknown' }}
                      </td>
                      <td>
                        <?php echo round($client->count / $day->total * 100, 2); ?>% ({{ client.count }})
                      </td>
                      <td>
                       <?php echo round($client->reward / $day->reward * 100, 2); ?>% (${{ client.reward }})
                      </td>
                    </tr>
                    {% endfor %}
                  </tbody>
                </table>
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
