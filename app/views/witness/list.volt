{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui top aligned stackable grid container">
    <div class="row">
      <div class="sixteen wide column">
        <div class="ui huge header">
          Witnesses
          <div class="sub header">
            DPOS elected witnesses and relevant historical information.
          </div>
        </div>
        <div style="overflow-x:auto;">
          <div class="ui top attached tabular menu">
            <a class="active item" href="/witnesses">Witnesses</a>
            <a class="item" href="/witness/history">History</a>
            <a class="item" href="/witness/misses">Misses</a>
          </div>
          <div class="ui bottom attached segment">
            <div class="ui active tab">
              <table class="ui small unstackable table">
                <thead>
                  <tr>
                    <th class="right aligned">Rank</th>
                    <th>Witness</th>
                    <th>Votes</th>
                    <th class="center aligned">
                      Weekly<br>
                      &amp; Total<br>
                      Misses
                    </th>
                    <th>Price Feed</th>
                    <th>
                      Reg Fee<br>
                      APR<br>
                      Block Size
                    </th>
                    <th>Version</th>
                    <th>VESTS</th>
                  </tr>
                </thead>
                <tbody>
                  {% for witness in witnesses %}
                    <tr class="{{ witness.row_status }}">
                      <td class="right aligned collapsing">
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
                        <div class="ui header">
                          <?php echo $this->largeNumber::format($witness->votes); ?>
                        </div>
                      </td>
                      <td class="center aligned">
                        <a href="/@{{ witness.owner }}/missed" class="ui small header">
                          {% if witness.invalid_signing_key %}
                          <i class="warning sign icon" data-popup data-title="Witness Disabled" data-content="This witness does not have a signing key either at the owners request or because too many blocks have been missed."></i>
                          {% endif %}
                          <div class="content">
                            {% if witness.misses_7day > 0 %}
                              <div class="ui tiny grey label">
                                {{ '+' ~ witness.misses_7day }}
                              </div>
                            {% else %}
                              ~
                            {% endif %}
                            <div class="sub header">
                              <small>{{ witness.total_missed }}</small>
                            </div>
                          </div>
                        </a>
                      </td>
                      <td>
                        <div class="ui header">
                          {% if witness.sbd_exchange_rate.base === "0.000 STEEM" or witness.last_sbd_exchange_update_late %}<i class="warning sign icon" data-popup data-title="Outdated Price Feed" data-content="This witness has not submitted a price feed update in over a week."></i>{% endif %}
                          <div class="content">
                            {{ witness.sbd_exchange_rate.base }}
                            {% if witness.sbd_exchange_rate.quote != "1.000 STEEM" %}
                            (<?php echo round((1 - 1/explode(" ", $witness->sbd_exchange_rate['quote'])[0]) * 100, 1) ?>%)
                            {% endif %}
                            <div class="sub header">
                              {{ witness.sbd_exchange_rate.quote }}<br>
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
                        <br>
                        {{ witness.props.sbd_interest_rate / 100 }}<small>%</small> APR
                        <br>
                        {{ witness.props.maximum_block_size }}
                      </td>
                      <td>
                        {{ witness.running_version }}
                      </td>
                      <td>
                        {{ partial("_elements/vesting_shares", ['current': witness.account[0]]) }}
                      </td>
                    </tr>
                  {% endfor %}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
{% endblock %}
