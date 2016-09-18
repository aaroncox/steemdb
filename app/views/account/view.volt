{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui stackable grid container">
    <div class="row">
      <div class="sixteen wide column">
        <div class="ui stackable grid">
          <div class="row">
            <div class="thirteen wide column">
              <div class="ui huge header">
                <span class="ui circular blue label" style="margin-left: 0">
                  <?php echo $this->reputation::number($account->reputation) ?>
                </span>
                {{ account.name }}
                <span class="mobile visible">
                  {{ partial("_elements/vesting_shares", ['current': account]) }}
                </span>
                <div class="sub header">
                  Updated <?php echo $this->timeAgo::mongo($account->scanned); ?>
                </div>
              </div>
            </div>
            <div class="three wide right aligned mobile hidden column">
              {{ partial("_elements/vesting_shares", ['current': account]) }}
            </div>
          </div>
        </div>
        <div class="ui top attached tabular menu">
          {{ link_to(["for": "account-view", "account": account.name], "Overview", "class": "item" ~ (router.getActionName() == "view" ? " active" : "")) }}
          {{ link_to(["for": "account-view-section", "account": account.name, "action": "posts"], "Posts", "class": "item" ~ (router.getActionName() == "posts" ? " active" : "")) }}
          {{ link_to(["for": "account-view-section", "account": account.name, "action": "votes"], "Votes", "class": "item" ~ (router.getActionName() == "votes" ? " active" : "")) }}
          {{ link_to(["for": "account-view-section", "account": account.name, "action": "replies"], "Replies", "class": "item" ~ (router.getActionName() == "replies" ? " active" : "")) }}
          {{ link_to(["for": "account-view-section", "account": account.name, "action": "followers"], "Followers", "class": "item" ~ (router.getActionName() == "followers" ? " active" : "")) }}
          {{ link_to(["for": "account-view-section", "account": account.name, "action": "following"], "Following", "class": "item" ~ (router.getActionName() == "following" ? " active" : "")) }}
          {{ link_to(["for": "account-view-section", "account": account.name, "action": "witness"], "Witness", "class": "item" ~ (router.getActionName() == "witness" ? " active" : "")) }}
          {{ link_to(["for": "account-view-section", "account": account.name, "action": "blocks"], "Blocks", "class": "item" ~ (router.getActionName() == "blocks" ? " active" : "")) }}
          {{ link_to(["for": "account-view-section", "account": account.name, "action": "data"], "Data", "class": "item" ~ (router.getActionName() == "data" ? " active" : "")) }}
        </div>
        <div class="ui bottom attached segment">
          {% include "account/view/" ~ router.getActionName() %}
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
