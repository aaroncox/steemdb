{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui large header">
          Biggest Account Power Downs
          <div class="sub header">
            Over the last 30 days
          </div>
        </div>
        <table class="ui attached table">
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
                  +<?php echo $this->largeNumber::format($powerdown->deposited, ''); ?> STEEM
                  <div class="sub header">
                    {{ powerdown.count }}x Power Downs
                  </div>
                </div>
              </td>
              <td class="collapsing right aligned">
                <div class="ui <?php echo $this->largeNumber::color($powerdown->withdrawn)?> label" data-popup data-content="<?php echo number_format($powerdown->withdrawn, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
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
