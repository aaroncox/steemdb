{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui stackable grid container">
    <div class="row">
      <div class="twelve wide column">
        <div class="ui top attached menu">
          {{ link_to(["for": "account-view", "account": account.name], "Overview", "class": "item" ~ (router.getActionName() == "view" ? " active" : "")) }}
          <div class="ui dropdown item">
            Activity
            <i class="dropdown icon"></i>
            <div class="menu">
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "posts"], "Posts", "class": "item" ~ (router.getActionName() == "posts" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "votes"], "Votes", "class": "item" ~ (router.getActionName() == "votes" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "replies"], "Replies", "class": "item" ~ (router.getActionName() == "replies" ? " active" : "")) }}
            </div>
          </div>
          <div class="ui dropdown item">
            Social
            <i class="dropdown icon"></i>
            <div class="menu">
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "followers"], "Followers", "class": "item" ~ (router.getActionName() == "followers" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "following"], "Following", "class": "item" ~ (router.getActionName() == "following" ? " active" : "")) }}
            </div>
          </div>
          <div class="ui dropdown item">
            Witness
            <i class="dropdown icon"></i>
            <div class="menu">
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "witness"], "Voting", "class": "item" ~ (router.getActionName() == "witness" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "blocks"], "Blocks", "class": "item" ~ (router.getActionName() == "blocks" ? " active" : "")) }}
              {{ link_to(["for": "account-view-section", "account": account.name, "action": "missed"], "Missed", "class": "item" ~ (router.getActionName() == "missed" ? " active" : "")) }}
            </div>
          </div>
          {{ link_to(["for": "account-view-section", "account": account.name, "action": "data"], "Data", "class": "item" ~ (router.getActionName() == "data" ? " active" : "")) }}
        </div>
        <div class="ui bottom attached segment">
          {% include "account/view/" ~ router.getActionName() %}
        </div>
      </div>
      <div class="four wide column">
        {% include '_elements/cards/account.volt' %}
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
        <table class="ui definition table">
          <tbody>
            <tr>
              <td>VESTS</td>
              <td>{{ partial("_elements/vesting_shares", ['current': account]) }}</td>
            </tr>
            <tr>
              <td>STEEM</td>
              <td><?php echo number_format($account->balance, 3, '.', ','); ?></td>
            </tr>
            <tr>
              <td>SBD</td>
              <td><?php echo number_format($account->sbd_balance, 3, '.', ','); ?></td>
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
{% endblock %}

{% block scripts %}
  {% if chart is defined %}
    {% include 'charts/account/' ~ router.getActionName() %}
  {% endif %}
{% endblock %}
