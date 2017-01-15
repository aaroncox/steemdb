{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui large header">
          Biggest Account Power Ups
          <div class="sub header">
            Largest total steem powered up per account
          </div>
        </div>
        <div class="ui menu">
          <a href="?filter=month" class="{{ (filter == 'month' or filter == '') ? 'active' : '' }} item">30 Days</a>
          <a href="?filter=week" class="{{ (filter == 'week') ? 'active' : '' }} item">7 Days</a>
          <a href="?filter=day" class="{{ (filter == 'day') ? 'active' : '' }} item">24 Hours</a>
        </div>
        <table class="ui attached table">
          <thead>
            <tr>
              <th class="right aligned">Power Up</th>
              <th class="right aligned">Vests</th>
              <th>Account</th>
            </tr>
          </thead>
          <tbody>
            {% for powerup in powerups %}
            <tr>
              <td class="collapsing right aligned">
                <div class="ui header">
                  +<?php echo $this->largeNumber::format($powerup->total, ''); ?>
                  <div class="sub header">
                    {{ powerup.count }}x Power Ups
                  </div>
                </div>
              </td>
              <td class="collapsing right aligned">
                {{ partial("_elements/vesting_shares", ['current': powerup.account[0]]) }}
              </td>
              <td>
                <div class="ui header">
                  <div class="ui circular blue label">
                    <?php echo $this->reputation::number($powerup->account[0]->reputation) ?>
                  </div>
                  {{ link_to("/@" ~ powerup.account[0].name, powerup.account[0].name) }}
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
