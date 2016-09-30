{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}

<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui large header">
          Vote Focusing
          <div class="sub header">
            Voters who focus their votes on specific authors in the last 30 days.
          </div>
        </div>
        <table class="ui collapsing table">
          <thead>
            <tr>
              <th>Account Weight</th>
              <th>Voter</th>
              <th>Author</th>
              <th>Votes</th>
              <th>Average Weight</th>
            </tr>
          </thead>
          <tbody>
            {% for focused in focus %}
              <tr>
                <td class="right aligned">
                  <div class="ui <?php echo $this->largeNumber::color($focused['account'][0]['vesting_shares'])?> label" data-popup data-content="<?php echo number_format($focused['account'][0]['vesting_shares'], 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                    <?php echo $this->largeNumber::format($focused['account'][0]['vesting_shares']); ?>
                  </div>
                </td>
                <td>
                  <a href="/@{{ focused._id.voter }}">
                    {{ focused._id.voter }}
                  </a>
                </td>
                <td>
                  <a href="/@{{ focused._id.author }}">
                    {{ focused._id.author }}
                  </a>
                </td>
                <td>
                  {{ focused.count }}
                </td>
                <td>
                  <?= round($focused->weight / 100) ?>%
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
