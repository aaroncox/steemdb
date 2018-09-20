{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}

<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <h1 class="ui header">
      Curation Rewards Leaderboard
      <div class="sub header">
        The top earning curators by date
      </div>
    </h1>
    <div class="row">
      <div class="column">
        <div class="ui top attached menu">
          {% if grouping %}
          <a href="/labs/curation?date={{ date('Y-m', date - 86400)}}{{ grouping ? '&grouping=' ~ grouping : '' }}" class="item">
            <i class="left arrow icon"></i>
            <span class="mobile hidden">{{ date('Y-m', date - 86400)}}</span>
          </a>
          {% else %}
          <a href="/labs/curation?date={{ date('Y-m-d', date - 86400)}}{{ grouping ? '&grouping=' ~ grouping : '' }}" class="item">
            <i class="left arrow icon"></i>
            <span class="mobile hidden">{{ date('Y-m-d', date - 86400)}}</span>
          </a>
          {% endif %}
          <a class="item" href="/labs/curation?date={{ date('Y-m-d')}}">
            Jump to Today
          </a>
          <div class="ui dropdown item">
            {{ (grouping ? grouping : 'Daily') | capitalize }}
            <i class="dropdown icon"></i>
            <div class="menu">
              <a class="{{ grouping == 'daily' ? 'active' : '' }} item" href="/labs/curation">
                Daily
              </a>
              <a class="{{ grouping == 'monthly' ? 'active' : '' }} item" href="/labs/curation?grouping=monthly">
                Monthly
              </a>
            </div>
          </div>
          <div class="right menu">
            {% if grouping %}
            <?php if(date('Y-m', $date) == date('Y-m')): ?>
            <a class="disabled item">
              <span class="mobile hidden">{{ date('Y-m', date + 86400 * 31)}}</span>
              <i class="right arrow icon"></i>
            </a>
            <?php else: ?>
            <a href="/labs/curation?date={{ date('Y-m', date + 86400 * 31)}}{{ grouping ? '&grouping=' ~ grouping : '' }}" class="item">
              <span class="mobile hidden">{{ date('Y-m', date + 86400 * 31)}}</span>
              <i class="right arrow icon"></i>
            </a>
            <?php endif ?>
            {% else %}
              <?php if($date > time() - 86400): ?>
              <a class="disabled item">
                <span class="mobile hidden">{{ date('Y-m-d', date + 86400)}}</span>
                <i class="right arrow icon"></i>
              </a>
              <?php else: ?>
              <a href="/labs/curation?date={{ date('Y-m-d', date + 86400)}}{{ grouping ? '&grouping=' ~ grouping : '' }}" class="item">
                <span class="mobile hidden">{{ date('Y-m-d', date + 86400)}}</span>
                <i class="right arrow icon"></i>
              </a>
              <?php endif ?>
            {% endif %}
          </div>
        </div>
        <div class="ui segment">
          <div class="ui header">
            Curation Leaderboard for
            {% if grouping %}
              {{ date('Y-m', date) }}
            {% else %}
              {{ date('Y-m-d', date) }}
            {% endif %}
            <div class="sub header">
              The accounts earning the highest curation rewards by day.
            </div>
          </div>
          <table class="ui table">
            <thead>
              <tr>
                <th class="collapsing">#</th>
                <th>Account</th>
                <th class="center aligned collapsing">Account Size</th>
                <th class="center aligned collapsing">Rewards</th>
                <th class="center aligned collapsing">Rewards Count</th>
                <th class="center aligned collapsing">Unique Authors</th>
              </tr>
            </thead>
            <tbody></tbody>
          {% for account in leaderboard %}
            <tr>
              <td>
                #{{ loop.index }}
              </td>
              <td>
                <a href="/@{{ account._id }}">
                  {{ account._id }}
                </a>
              </td>
              <td class="center aligned collapsing">
                {{ partial("_elements/vesting_shares", ['current': account.account[0]]) }}
                <br>
                <small>
                  ~<?php echo $this->convert::vest2sp($account->account[0]->vesting_shares, ""); ?>&nbsp;SP*
                </small>

              </td>
              <td class="center aligned collapsing">
                <div class="ui <?php echo $this->largeNumber::color($account->total)?> label" data-popup data-content="<?php echo number_format($account->total, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                  <?php echo $this->largeNumber::format($account->total); ?>
                </div>
                <br>
                <small>
                  ~<?php echo $this->convert::vest2sp($account->total, ""); ?> SP*
                </small>
              </td>
              <td class="center aligned collapsing">
                {{ account.count }}
              </td>
              <td class="center aligned collapsing">
                {{ account.authors | length }}
              </td>
            </tr>
          {% else %}
          <tr>
            <td colspan="10">
              <div class="ui message">
                No data for this date
              </div>
            </td>
          </tr>
          {% endfor %}
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

{% endblock %}

{% block scripts %}

{% endblock %}
