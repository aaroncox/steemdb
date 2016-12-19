{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui huge dividing header">
          Power Down Statistics
          <div class="sub header">
            Analysis of the accounts currently powering down (using UTC time)
          </div>
        </div>
        <div class="ui small three statistics">
          <div class="statistic">
            <div class="label">
              Liquid Steem
            </div>
            <div class="value">
              <?php echo number_format($props['liquid'], 0, ".", ",") ?>
            </div>
          </div>          <div class="statistic">
            <div class="label">
              Current Supply
            </div>
            <div class="value">
              <?php echo number_format($props['current'], 0, ".", ",") ?>
            </div>
          </div>
          <div class="statistic">
            <div class="label">
              Total Vesting Fund
            </div>
            <div class="value">
              <?php echo number_format($props['vesting'], 0, ".", ",") ?>
            </div>
          </div>

        </div>
        <div class="ui divider"></div>
      </div>
    </div>
    <div class="row">
      <div class="seven wide column">
        <div class="ui centered header">
          Pending Power Downs
          <div class="sub header">
            Total powering down in the next week
          </div>
        </div>
        <table class="ui small striped table">
          <thead>
            <tr>
              <th>Total (Weekly)</th>
              <th class="right aligned"><?php echo number_format($upcoming_total, 0, ".", ",") ?> VESTS</th>
              <th class="right aligned">~<?php echo $this->convert::vest2sp($upcoming_total, " STEEM", 0); ?></th>
            </tr>
          </thead>
          <tbody>
            {% for day in upcoming %}
            <tr>
              <td>
                {{ dow[day['_id']['dow']] }}
                &mdash;
                {{ day['_id']['month'] }}-{{ day['_id']['day'] }}
                {% if loop.index == 1 %}
                  (<strong>Today</strong>)
                {% endif %}
              </td>
              <td class="right aligned"><?php echo number_format($day->withdrawn, 0, ".", ",") ?> VESTS</td>
              <td class="right aligned">~<?php echo $this->convert::vest2sp($day->withdrawn, " STEEM", 0); ?></td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
      <div class="two wide column">
        <div class="ui centered header">
          Difference
          <div class="sub header">
            % Change
          </div>
        </div>
        <table class="ui small striped table">
          <thead>
            <th class="right aligned">
              <?php $number = round(($upcoming_total / $previous_total - 1) * 100 ,2); ?>
              {% if number > 0 %}
              <div style="color: #DB2828">
              {% else %}
              <div style="color: #16ab39">
              {% endif %}
                {{ number }}%
              </span>
            </th>
          </thead>
          <tbody>
            {% for idx, day in upcoming %}
            <tr>
              <td class="mobile visible">
                {{ dow[day['_id']['dow']] }}
                &mdash;
                {{ day['_id']['month'] }}-{{ day['_id']['day'] }}
              </td>
              <td class="right aligned">
                <?php
                  $withdrawn = $day['withdrawn'];
                  if($upcoming[8]) {
                    $withdrawn += $upcoming[8]['withdrawn'];
                  }
                  $number = round(($withdrawn / $previous[$idx]['withdrawn'] - 1) * 100, 1);
                 ?>
                {% if number > 0 %}
                <div style="color: #DB2828">
                {% else %}
                <div style="color: #16ab39">
                {% endif %}
                  {{ number }}%
                </span>
              </td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
      <div class="seven wide column">
        <div class="ui centered header">
          Completed Power Downs
          <div class="sub header">
            Total powered down in the last week
          </div>
        </div>
        <table class="ui small striped table">
          <thead>
            <tr>
              <th>Total</th>
              <th class="right aligned"><?php echo number_format($previous_total, 0, ".", ",") ?> VESTS</th>
              <th class="right aligned">~<?php echo $this->convert::vest2sp($previous_total, " STEEM", 0); ?></th>
            </tr>
          </thead>
          <tbody>
            {% for day in previous %}
            <tr>
              <td>
                {{ dow[day['_id']['dow']] }}
                &mdash;
                {{ day['_id']['month'] }}-{{ day['_id']['day'] }}
              </td>
              <td class="right aligned"><?php echo number_format($day->withdrawn, 0, ".", ",") ?> VESTS</td>
              <td class="right aligned">~<?php echo $this->convert::vest2sp($day->withdrawn, " STEEM", 0); ?></td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
    </div>
    <div class="row">
      <div class="column">
        <div class="ui divider"></div>
        <div class="ui header">
          Largest Liquidity Increases
          <div class="sub header">
            30 days worth of powerdowns combined per account
          </div>
        </div>
        <table class="ui small striped attached table">
          <thead>
            <tr>
              <th></th>
              <th class="right aligned">Steem Deposited</th>
              <th class="right aligned">Vests Withdrawn</th>
              <th>Vests Remaining</th>
              <th>Account Withdrawing</th>
              <th>Account(s) Receiving</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {% for powerdown in powerdowns %}
            <tr>
              <td class="collapsing">{{ loop.index }}</td>
              <td class="collapsing right aligned">
                <div class="ui header">
                  +<?php echo $this->largeNumber::format($powerdown->deposited, '', " STEEM", 0); ?>
                  <div class="sub header">
                    {{ powerdown.count }}x Power Downs
                  </div>
                </div>
              </td>
              <td class="collapsing right aligned">
                <div class="ui <?php echo $this->largeNumber::color($powerdown->withdrawn)?> label" data-popup data-content="<?php echo number_format($powerdown->withdrawn, 0, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                  -<?php echo $this->largeNumber::format($powerdown->withdrawn); ?>
                </div>
              </td>
              <td class="collapsing right aligned">
                {{ partial("_elements/vesting_shares", ['current': powerdown.account[0]]) }}
              </td>
              <td>
                <div class="ui header">
                  <div class="ui circular blue label">
                    <?php echo $this->reputation::number($powerdown->account[0]->reputation) ?>
                  </div>
                  {{ link_to("/@" ~ powerdown.account[0].name, powerdown.account[0].name) }}
                  <div class="sub header" style="margin-left: 50px">
                    <a href="/@{{ powerdown.account[0].name }}/powerdown">
                      Power Downs
                    </a>
                    |
                    <a href="/@{{ powerdown.account[0].name }}/transfers">
                      Transfers
                    </a>
                  </div>
                </div>
              </td>
              <td>
                <div class="ui list">
                {% for account in powerdown.deposited_to %}
                  <div class="item">
                    <a href="/@{{ account }}">
                      {{ account }}
                    </a>
                  </div>
                {% endfor %}
                </div>
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
