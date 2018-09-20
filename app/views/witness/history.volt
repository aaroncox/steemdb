{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui top aligned stackable grid container">
    <div class="row">
      <div class="twelve wide column">
        <div style="overflow-x:auto;">
          <div class="ui top attached tabular menu">
            <a class="item" href="/witnesses">Witnesses</a>
            <a class="active item" href="/witness/history">History</a>
            <a class="item" href="/witness/misses">Misses</a>
          </div>
          <div class="ui bottom attached segment">
            <div class="ui active tab">
              <table class="ui table">
                <thead>
                  <tr>
                    <th>Voter</th>
                    <th class="collapsing"></th>
                    <th>Witness</th>
                    <th>MVests</th>
                    <th class="three wide">When</th>
                  </tr>
                </thead>
                <tbody>
                {% for vote in votes %}
                  <tr>
                    <td>
                      <a href="/@{{ vote.account }}">
                        {{ vote.account }}
                      </a>
                    </td>
                    <td>
                      {% if vote.approve %}
                      <span class="ui purple basic label">
                        Approved
                      </span>
                      {% else %}
                      <span class="ui orange basic label">
                        Unapproved
                      </span>
                      {% endif %}
                    </td>
                    <td>
                      <a href="/@{{ vote.witness }}">
                        {{ vote.witness }}
                      </a>
                    </td>
                    <td>
                      {{ partial("_elements/witness_vesting_shares", ['weight': vote.weight]) }}
                    </td>
                    <td>
                      <?php echo $this->timeAgo::mongo($vote->_ts); ?>
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
