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
                <div class="sub header">
                  Updated <?php echo $this->timeAgo::mongo($account->scanned); ?>
                </div>
              </div>
            </div>
            <div class="three wide right aligned column">
              {{ partial("_elements/vesting_shares", ['current': account]) }}
            </div>
          </div>
        </div>
        <div class="ui top attached tabular menu">
          <a class="active item" data-tab="overview">Overview</a>
          <a class="item" data-tab="posts">Posts</a>
          <a class="item" data-tab="votes">Votes</a>
          <a class="item" data-tab="replies">Replies</a>
          <a class="item" data-tab="followers">Followers</a>
          <a class="item" data-tab="following">Following</a>
          <a class="item" data-tab="witness">Witness</a>
          {% if mining | length > 0 %}
          <a class="item" data-tab="mining">Mining</a>
          {% endif %}
          <a class="item" data-tab="data">Raw Data</a>
        </div>
        <div class="ui bottom attached segment">
          <div class="ui active tab" data-tab="overview">
            {% include "account/view/overview.volt" %}
          </div>
          <div class="ui tab" data-tab="posts">
            {% include "account/view/posts.volt" %}
          </div>
          <div class="ui tab" data-tab="votes">
            {% include "account/view/votes.volt" %}
          </div>
          <div class="ui tab" data-tab="replies">
            {% include "account/view/replies.volt" %}
          </div>
          <div class="ui tab" data-tab="following">
            {% include "account/view/following.volt" %}
          </div>
          <div class="ui tab" data-tab="followers">
            {% include "account/view/followers.volt" %}
          </div>
          <div class="ui tab" data-tab="witness">
            {% include "account/view/witness.volt" %}
          </div>
          <div class="ui tab" data-tab="mining">
            {% include "account/view/mining.volt" %}
          </div>
          <div class="ui tab" data-tab="data">
            {% include "account/view/data.volt" %}
          </div>
        </div>
      </div>
<!--
      <div class="four wide column">

      </div>
 -->
    </div>
  </div>
</div>
{% endblock %}

{% block scripts %}
{% include 'charts/account/overview.volt' %}
{% include 'charts/account/mining.volt' %}
{% include 'charts/account/votes.volt' %}
{% include 'charts/account/posts.volt' %}
<script>
  $('.tabular.menu .item')
    .tab({
      onVisible: function(tab) {
        if(typeof window.steemdb['chart_' + tab] !== "undefined") {
          window.steemdb['chart_' + tab]();
          delete window.steemdb['chart_' + tab];
        }
      }
    })
  ;
</script>
{% endblock %}
