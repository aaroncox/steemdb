{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui large header">
          Voting Data
          <div class="sub header">

          </div>
        </div>
        <table class="ui table">
          <thead>
            <tr>
              <th>Date</th>
              <th>Votes</th>
              <th>Average Weight</th>
              <th>Self-votes</th>
              <th>Average Weight (Self-Votes)</th>
            </tr>
          </thead>
          <tbody>
            {% for result in results %}
            <tr>
              <td>
                {{ result._id.year }}-{{ result._id.month }}-{{ result._id.day }}
              </td>
              <td>
                {{ result['count'] }}
              </td>
              <td>
                <?php echo round($result['weight'] / 100, 2) ?>%
              </td>
              <td>
                {{ result['self'] }}
              </td>
              <td>
                <?php echo round($result['self_weight'] / 100, 2) ?>%
              </td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

{% endblock %}

{% block scripts %}

{% endblock %}
