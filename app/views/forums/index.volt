{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui hidden divider"></div>
{% if perfLogger %}
<table class="ui striped definition table">
  <thead>
    <tr>
      <th>Forum</th>
      <th>op</th>
      <th>millis</th>
      <th>examined</th>
      <th>index</th>
    </tr>
  </thead>
  <tbody>
  {% for forum, perf in perfLog %}
    {% for op, data in perf %}
    <tr>
      <td>{{ forum }}</td>
      <td>{{ op }}</td>
      <td>{{ data.executionStats.executionTimeMillis }}ms</td>
      <td>{{ data.executionStats.totalKeysExamined }}</td>
      <td>
        {% if data.queryPlanner.winningPlan is defined and data.queryPlanner.winningPlan.inputStage is defined %}
          {#{% include "_elements/definition_table" with ['data': data.queryPlanner.winningPlan.inputStage.inputStage.inputStage] %}#}
          {{ data.queryPlanner.winningPlan.inputStage.inputStage.indexName }}
          {{ data.queryPlanner.winningPlan.inputStage.inputStage.inputStage.indexName }}
        {% endif %}
      </td>
      <td>

      </td>
      <td>
        {#{% include "_elements/definition_table" with ['data':  data.queryPlanner.winningPlan] %}#}
      </td>
    </tr>
    {% endfor %}
  {% endfor %}
  </tbody>
</table>
{% else %}
<div class="ui container">
  <div class="ui vertically divided grid">
    <div class="row">
      <div class="column">
        <div class="ui large header">
          Steem Forums Prototype
          <div class="sub header">
            An experimental view of the STEEM blockchain, organized in a traditional forum layout. It's not very optimized which may cause some page to load slowly.
          </div>
        </div>
        <div class="ui warning message">
          Notice: New posts may take up to 1 minute to show within this forum view (data is based on last irreverisble block, not head).
        </div>
      </div>
    </div>
    {% include 'forums/_breadcrumb.volt' %}
    {% for category in forums %}
    <div class="row">
      <div class="column">
        <div class="ui small header">
          {{ category['name'] }}
        </div>
        <table class="ui striped unstackable table">
          <thead>
            <tr>
              <th></th>
              <th>Category</th>
              <th class="center aligned mobile hidden">Posts</th>
              <th>Latest Post</th>
            </tr>
          </thead>
          <tbody>
            {% for id, board in category['boards'] %}
            <tr>
              <td class="collapsing">
                {% if board['tags'] %}
                <i class="hashtag large bordered fitted icon"></i>
                {% elseif board['accounts'] %}
                <i class="user large bordered fitted icon"></i>
                {% else %}
                <i class="list large bordered fitted icon"></i>
                {% endif %}
              </td>
              <td>
                <div class="ui header">
                  <a href="/forums/{{ id }}">
                    {{ board['name'] }}
                  </a>
                  <div class="sub header">
                    &#x21b3;
                    {% if not board['tags'] and not board['accounts'] %}
                    All posts
                    {% endif %}
                    {% for tag in board['tags'] %}
                      <a href="/forums/tag/{{ tag }}">
                        #{{ tag }}
                      </a>
                    {% endfor %}
                    {% for account in board['accounts'] %}
                      <a href="/@{{ account }}">
                        @{{ account }}
                      </a>
                    {% endfor %}
                  </div>
                </div>
              </td>
              <td class="two wide center aligned mobile hidden">
                {% if board['posts'] is defined %}
                <div class="ui mini statistic">
                  <div class="value">
                    {{ board['posts'] }}
                  </div>
                  <div class="label">
                    posts
                  </div>
                </div>
                {% endif %}
              </td>
              <td class="six wide">
                {% if board['recent'] is defined %}
                  <a href="/forums{{ board['recent'].url }}">
                    {{ board['recent'].title }}
                  </a>
                  <br>
                  <a href="/@{{ board['recent'].author }}">
                    @{{ board['recent'].author }}
                  </a>
                  <small>
                    {% if board['recent'].last_reply %}
                      <?php echo $this->timeAgo::mongo($board['recent']->last_reply); ?>
                    {% else %}
                      <?php echo $this->timeAgo::mongo($board['recent']->created); ?>
                    {% endif %}
                  </small>
                {% endif %}
              </td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
    </div>
    {% endfor %}
    {% include 'forums/_breadcrumb.volt' %}
  </div>
</div>
{% endif %}
{% endblock %}

{% block scripts %}

{% endblock %}
