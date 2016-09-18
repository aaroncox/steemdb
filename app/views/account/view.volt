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
    </div>
  </div>
</div>
{% endblock %}

{% block scripts %}
  {% if chart is defined %}
    {% include 'charts/account/' ~ router.getActionName() %}
  {% endif %}
{% endblock %}
