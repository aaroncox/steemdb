{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui top aligned stackable grid container">
    <div class="row">
      <div class="twelve wide column">
        <table class="ui small unstackable table">
          <thead>
            <tr>
              <th>#</th>
              <th>Witness</th>
              <th>Votes</th>
              <th>Misses</th>
              <th>Last Block</th>
              <th>Feed</th>
              <th>Reg Fee</th>
              <th>APR</th>
              <th>Block Size</th>
              <th>Version</th>
            </tr>
          </thead>
          <tbody>
            {% for witness in witnesses %}
              <tr class="{{ witness.row_status }}">
                <td class="collapsing">
                  {% if loop.index <= 19 %}
                    <strong>{{ loop.index }}</strong>
                  {% else %}
                    {{ loop.index }}
                  {% endif %}
                </td>
                <td>
                  <div class="ui header">
                    <a href="/@{{ witness.owner }}">
                      {{ witness.owner }}
                    </a>
                    <div class="sub header">
                      <a href="{{ witness.url }}">
                        witness url
                      </a>
                    </div>
                  </div>
                </td>
                <td class="collapsing">
                  <?php echo $this->largeNumber::format($witness->votes); ?>
                </td>
                <td>
                  {{ witness.total_missed }}
                </td>
                <td>
                  {{ witness.last_confirmed_block_num }}
                </td>
                <td>
                  <div class="ui small header">
                    {% if witness.sbd_exchange_rate.base === "0.000 STEEM" or witness.last_sbd_exchange_update_late %}<i class="warning sign icon"></i>{% endif %}
                    <div class="content">
                      {{ witness.sbd_exchange_rate.base }}
                      <div class="sub header">
                        {% if "" ~ witness.last_sbd_exchange_update > 0 %}
                          <?php echo $this->timeAgo::mongo($witness->last_sbd_exchange_update); ?>
                        {% else %}
                          Never
                        {% endif %}
                      </div>
                    </div>
                  </div>
                </td>
                <td>
                  {{ witness.props.account_creation_fee }}
                </td>
                <td>
                  {{ witness.props.sbd_interest_rate / 100 }}<small>%</small>
                </td>
                <td>
                  {{ witness.props.maximum_block_size }}
                </td>
                <td>
                  {{ witness.running_version }}
                </td>
              </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
      <div class="four wide column">
        <div class="ui header">
          Miner Queue
        </div>
        <div class="ui divided list">
        {% for miner in queue.value %}
          <div class="ui item">
            {{ loop.index }}.
            <a href="/@{{ miner }}">
              {{ miner }}
            </a>
          </div>
        {% endfor %}
        </div>
      </div>
    </div>
  </div>
</div>
{% endblock %}
