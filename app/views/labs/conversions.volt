{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui large header">
          Recent SBD -> STEEM Conversions
          <div class="sub header">
            Ordered chronologically, limited to 1000 conversions.
          </div>
        </div>
        <table class="ui attached table">
          <thead>
            <tr>
              <th class="right aligned collapsing">Date</th>
              <th class="right aligned collapsing">Account</th>
              <th class="right aligned collapsing">Amount</th>
              <th>RequestID</th>
            </tr>
          </thead>
          <tbody>
            {% for current in conversions %}
            <tr>
              <td class="collapsing right aligned">
                <div class="sub header">
                  <?php echo gmdate("Y-m-d H:i:s e", (string) $current->_ts / 1000) ?>
                </div>
              </td>
              <td class="collapsing right aligned">
                <a href="/@{{ current.owner }}">
                  {{ current.owner }}
                </a>
              </td>
              <td class="collapsing right aligned">
                <?php echo number_format($current->amount, 3, ".", ",") ?>&nbsp;SBD
              </td>
              <td>
                {{ current.requestid }}
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
