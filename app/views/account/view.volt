{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui stackable grid container">
    <div class="row">
      <div class="twelve wide column" id="main-context">
        <div class="ui top attached menu">
          {{ link_to(["for": "account-view", "account": account.name], "<i class='home icon'></i>", "class": "icon item" ~ (router.getActionName() == "view" ? " active" : "")) }}
          <div class="ui dropdown item">
            Activity
            <i class="dropdown icon"></i>
            <div class="menu">
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "posts"], "Posts", "class": "item" ~ (router.getActionName() == "posts" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "votes"], "Votes", "class": "item" ~ (router.getActionName() == "votes" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "replies"], "Replies", "class": "item" ~ (router.getActionName() == "replies" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "reblogs"], "Reblogs", "class": "item" ~ (router.getActionName() == "reblogs" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "authoring"], "Rewards", "class": "item" ~ (router.getActionName() == "authoring" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "transfers"], "Transfers", "class": "item" ~ (router.getActionName() == "transfers" ? " active" : "")) }}
            </div>
          </div>
          <div class="ui dropdown item">
            Social
            <i class="dropdown icon"></i>
            <div class="menu">
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "followers"], "Followers", "class": "item" ~ (router.getActionName() == "followers" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "following"], "Following", "class": "item" ~ (router.getActionName() == "following" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "reblogged"], "Reblogged", "class": "item" ~ (router.getActionName() == "reblogged" ? " active" : "")) }}
            </div>
          </div>
          <div class="ui dropdown item">
            Witness
            <i class="dropdown icon"></i>
            <div class="menu">
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "witness"], "Voting", "class": "item" ~ (router.getActionName() == "witness" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "blocks"], "Blocks", "class": "item" ~ (router.getActionName() == "blocks" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "missed"], "Missed", "class": "item" ~ (router.getActionName() == "missed" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "props"], "Props", "class": "item" ~ (router.getActionName() == "props" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "proxied"], "Proxied", "class": "item" ~ (router.getActionName() == "proxied" ? " active" : "")) }}
            </div>
          </div>
          {{ link_to(["for": "account-view-section", "account": account.name, "action": "data"], "Data", "class": "item" ~ (router.getActionName() == "data" ? " active" : "")) }}
        </div>
        {% if chart %}
        <div class="ui attached segment">
          <svg width="100%" height="200px" id="account-{{ router.getActionName() }}"></svg>
        </div>
        {% endif %}
        <div class="ui bottom attached secondary segment">
          {% include "account/view/" ~ router.getActionName() %}
        </div>
      </div>
      <div class="four wide column">
        <div class="ui sticky">
          {% include '_elements/cards/account.volt' %}
          <div class="ui small indicating progress">
            <div class="label">
              {{ live[0]['voting_power'] / 10000 * 100 }}% Voting Power
            </div>
            <div class="bar">
              <div class="progress"></div>
            </div>
          </div>
          <div class="ui list">
            <div class="item">
              <a href="https://steemit.com/@{{ account.name }}" class="ui fluid primary icon small basic button" target="_blank">
                <i class="external icon"></i>
                View Account on steemit.com
              </a>
            </div>
            <div class="item">
              <a href="https://steemd.com/@{{ account.name }}" class="ui fluid teal icon small basic button" target="_blank">
                <i class="external icon"></i>
                View Account on steemd.com
              </a>
            </div>
          </div>
          <table class="ui small definition table">
            <tbody>
              <tr>
                <td>VESTS</td>
                <td>
                  {{ partial("_elements/vesting_shares", ['current': account]) }}
                </td>
              </tr>
              <tr {% if account.vesting_withdraw_rate and account.vesting_withdraw_rate > 1 %}data-popup data-html="<table class='ui small definition table'><tr><td>Power Down - Rate</td><td>-<?php echo $this->convert::vest2sp($current->vesting_withdraw_rate, " SP"); ?></td></tr><tr><td>Power Down - Datetime</td><td><?php echo gmdate("Y-m-d H:i:s e", (string) $account->next_vesting_withdrawal / 1000) ?></td></tr></table>" data-position="left center" data-variation="very wide"{% endif %}>
                <td>SP</td>
                <td>
                  <div class="ui tiny header">
                    <?php echo $this->convert::vest2sp($current->vesting_shares); ?>
                  </div>
                </td>
              </tr>
              <tr data-popup data-html="<table class='ui small definition table'><tr><td>Balance</td><td><?php echo number_format($account->balance, 3, '.', ','); ?></td></tr><tr><td>Savings Balance</td><td><?php echo number_format($account->savings_balance, 3, '.', ','); ?></td></tr>{% if account.vesting_withdraw_rate and account.vesting_withdraw_rate > 1 and not account.withdraw_routes %}<tr><td>Power Down - Rate</td><td>+<?php echo $this->convert::vest2sp($current->vesting_withdraw_rate, " STEEM"); ?></td></tr><tr><td>Power Down - Datetime</td><td><?php echo gmdate("Y-m-d H:i:s e", (string) $account->next_vesting_withdrawal / 1000) ?></td></tr>{% endif %}</table>" data-position="left center" data-variation="very wide">
                <td>STEEM</td>
                <td>
                  <div class="ui tiny header">
                    <?php echo number_format($account->total_balance, 3, '.', ','); ?>
                  </div>
                </td>
              </tr>
              <tr data-popup data-html="<table class='ui small definition table'><tr><td>Balance</td><td><?php echo number_format($account->sbd_balance, 3, '.', ','); ?></td></tr><tr><td>Savings Balance</td><td><?php echo number_format($account->savings_sbd_balance, 3, '.', ','); ?></td></tr><tr><td>Next Interest (10% APY)</td><td><?php echo gmdate("Y-m-d H:i:s e", strtotime("+30 days", (string) $account->sbd_last_interest_payment / 1000)); ?></td></tr></table>" data-position="left center" data-variation="very wide">
                <td>SBD</td>
                <td>
                  <div class="ui tiny header">
                    <?php echo number_format($account->total_sbd_balance, 3, '.', ','); ?>
                    <div class="sub header">
                    </div>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <div class="ui tiny centered header">
            <span class="sub header">
              Account snapshot taken
              <?php echo $this->timeAgo::mongo($account->scanned); ?>
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
{% endblock %}

{% block scripts %}
  {% if chart is defined %}
    {% include 'charts/account/' ~ router.getActionName() %}
  {% endif %}
  <script>
    $('.ui.indicating.progress')
      .progress({
        percent: {{ live[0]['voting_power'] / 100 }}
      });
    $('.tabular.menu .item')
      .tab({

      });
    $('.ui.sticky')
      .sticky({
        context: '#main-context',
        offset: 90
      });
    $(".ui.sortable.table").tablesort();
  </script>
{% endblock %}
