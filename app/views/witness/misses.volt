{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui top aligned stackable grid container">
    <div class="row">
      <div class="twelve wide column">
        <div style="overflow-x:auto;">
          <div class="ui top attached tabular menu">
            <a class="item" href="/witnesses">Witnesses</a>
            <a class="item" href="/witness/history">History</a>
            <a class="active item" href="/witness/misses">Misses</a>
          </div>
          <div class="ui bottom attached segment">
            <div class="ui active tab">
              <table class="ui table">
                <thead>
                  <tr>
                    <th>Date/Time (Approximately)</th>
                    <th>Witness</th>
                    <th>Missed</th>
                    <th>Total Misses</th>
                  </tr>
                </thead>
                <tbody>
                {% for miss in history %}
                  <tr>
                    <td>
                      {{ miss.date.toDateTime().format("Y-m-d H:i:s") }} UTC
                    </td>
                    <td>
                      <a href="/@{{ miss.witness }}">
                        {{ miss.witness }}
                      </a>
                    </td>
                    <td>
                      +{{ miss.increase }}
                    </td>
                    <td>
                      {{ miss.total }}
                    </td>
                  </tr>
                {% endfor %}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
      <div class="four wide column">
        <div class="ui header">
          Most Misses (7-Day)
        </div>
        <div class="ui divided list">
        {% for witness in misses %}
          <div class="ui item">
            <div class="ui small label">
              +{{ witness.total }}
            </div>
            <a href="/@{{ witness._id }}">
              {{ witness._id }}
            </a>
          </div>
        {% endfor %}
        </div>
      </div>
    </div>
  </div>
</div>
{% endblock %}
