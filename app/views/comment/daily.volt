{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<style>
  .tooltip {
  /* keep tooltips from blocking interactions */
  pointer-events: none;
}
</style>
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui huge header">
          Posts from {{ date('Y-m-d', date)}}
          <div class="sub header">
            Sorted to show the
            <strong>
            {% if sort == 'votes' %}
              most voted
            {% else %}
              highest earning
            {% endif %}
            </strong>
            {% if tag !== 'all' %}
            tagged with
            <span class='ui icon label'>
              {{ tag }}
              <a href="/posts/all/{{ sort ? sort : 'earnings' }}/{{ date('Y-m-d', date)}}">
                <i class="close icon" style="margin-right: 0"></i>
              </a>
            </span>
            {% endif %}
            posts created on {{ date('Y-m-d', date)}}.
          </div>
        </div>
        <input type="hidden" id="selectedDate" value="{{ date('Y-m-d', date)}}">
        <input type="hidden" id="selectedSort" value="{{ sort ? sort : 'earnings' }}">
        <div class="ui menu">
          <a href="/posts/{{ tag ? tag : 'all' }}/{{ sort ? sort : 'earnings' }}/{{ date('Y-m-d', date - 86400)}}" class="item">
            <i class="left arrow icon"></i>
            <span class="mobile hidden">{{ date('Y-m-d', date - 86400)}}</span>
          </a>
          <div class="ui dropdown item">
            Sorting <i class="dropdown icon"></i>
            <div class="menu">
              <a href="/posts/{{ tag ? tag : 'all' }}/earnings/{{ date('Y-m-d', date)}}" class="item">
                Top Earning
              </a>
              <a href="/posts/{{ tag ? tag : 'all' }}/votes/{{ date('Y-m-d', date)}}" class="item">
                Most Votes
              </a>
            </div>
          </div>
<!--
          <div class="ui search selection dropdown tags item" style="border: none">
            <input type="hidden">
            <i class="dropdown icon"></i>
            <input type="text" class="search">
            <div class="default text">Select a tag...</div>
          </div>
 -->
          <div class="right menu">
            <?php if($date > time() - 86400): ?>
            <a class="disabled item">
              <span class="mobile hidden">{{ date('Y-m-d', date + 86400)}}</span>
              <i class="right arrow icon"></i>
            </a>
            <?php else: ?>
            <a href="/posts/{{ tag ? tag : 'all' }}/{{ sort ? sort : 'earnings' }}/{{ date('Y-m-d', date + 86400)}}" class="item">
              <span class="mobile hidden">{{ date('Y-m-d', date + 86400)}}</span>
              <i class="right arrow icon"></i>
            </a>
            <?php endif ?>
          </div>
        </div>
      </div>
    </div>
    {% include "_elements/comment_list.volt" %}
  </div>
</div>
{#
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="center aligned column">
        <table class="ui table">
          <thead>
            <tr>
              <th>Account</th>
              <th>Vesting</th>
            </tr>
          </thead>
          <tbody>
            {% for account in accounts %}
            <tr>
              <td>
                {{ link_to("/@" ~ account.name, account.name) }}
              </td>
              <td>{{ account.vesting_shares }}</td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
#}

{% endblock %}

{% block scripts %}
{% endblock %}
