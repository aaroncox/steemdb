{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui large header">
          Steem Benefactors
          <div class="sub header">
            Top Earning Benefactors by Date
          </div>
        </div>
        <table class='ui table'>
          <thead>
            <tr>
              <th>Date</th>
              <th>VESTS</th>
              <th>Posts</th>
            </tr>
          </thead>
          <tbody>
          {% for day in dates %}
            <tr>
              <td>
                {{ day._id.year }}-{{ day._id.month }}-{{ day._id.day }}
              </td>
              <td>
                {{ day.reward }}
              </td>
              <td>
                {{ day.total }}
              </td>
              <td class='collapsing'>
                <table class="ui compact small table">
                  <thead>
                    <tr>
                      <th>Benefactor</th>
                      <th>Posts</th>
                      <th>VESTS</th>
                    </tr>
                  </thead>
                  <tbody>
                    {% for benefactor in day.benefactors %}
                    <tr>
                      <td>
                        {{ (benefactor.benefactor) ? benefactor.benefactor : 'unknown' }}
                      </td>
                      <td>
                        <?php echo round($benefactor->count / $day->total * 100, 2); ?>% ({{ benefactor.count }})
                      </td>
                      <td>
                       <?php echo round($benefactor->reward / $day->reward * 100, 2); ?>% ({{ benefactor.reward }})
                      </td>
                    </tr>
                    {% endfor %}
                  </tbody>
                </table>
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
