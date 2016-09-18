{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui stackable grid container">
    <div class="row">
      <div class="twelve wide column">
        <div class="ui huge header">
          {{ comment.title }}
          <div class="sub header">
            by
            <a href="/@{{ comment.author }}">
              {{ comment.author }}
            </a>
          </div>
        </div>
        <div class="ui top attached tabular menu">
          <a class="active item" data-tab="post">Content</a>
          <a class="item" data-tab="tags">Tags ({{ comment.metadata('tags') | length }})</a>
          <a class="item" data-tab="replies">Replies ({{ comment.children }})</a>
          <a class="item" data-tab="votes">Votes ({{ comment.net_votes }})</a>
          <a class="item" data-tab="data">Raw Data</a>
        </div>
        <div class="ui bottom attached padded segment">
          <div class="ui active tab" data-tab="post">
            {% include "comment/view/content.volt" %}
          </div>
          <div class="ui tab" data-tab="tags">
            {% include "comment/view/tags.volt" %}
          </div>
          <div class="ui tab" data-tab="replies">
            {% include "comment/view/replies.volt" %}
          </div>
          <div class="ui tab" data-tab="votes">
            {% include "comment/view/votes.volt" %}
          </div>
          <div class="ui tab" data-tab="data">
            {% include "comment/view/data.volt" %}
          </div>
        </div>
      </div>
      <div class="four wide column">
        {% include '_elements/cards/account' with ['account': author] %}
        <div class="ui list">
          <div class="item">
            <a href="https://steemit.com{{ comment.url }}" class="ui fluid primary icon button" target="_blank">
              <i class="external icon"></i>
              View Post on steemit.com
            </a>
          </div>
          <div class="item">
            <a href="https://steemd.com{{ comment.url }}" class="ui fluid teal icon button" target="_blank">
              <i class="external icon"></i>
              View Post on steemd.com
            </a>
          </div>
        </div>
        {% include '_elements/sidebar/earnings.volt' %}
        {% include '_elements/sidebar/readmore.volt' %}
        {% include '_elements/sidebar/commands.volt' %}
      </div>
    </div>
  </div>
</div>
{% endblock %}

{% block scripts %}
<script>
  $('.tabular.menu .item')
    .tab({

    })
  ;
</script>
{% endblock %}
