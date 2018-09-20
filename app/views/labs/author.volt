{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}

<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <h1 class="ui header">
      Author Rewards Leaderboard
      <div class="sub header">
        Total rewards earnings by date and display of the top 500.
      </div>
    </h1>
    <div class="row">
      <div class="column">
        <div class="ui top attached menu">
          {% if grouping %}
          <a href="/labs/author?date={{ date('Y-m', date - 86400)}}{{ grouping ? '&grouping=' ~ grouping : '' }}" class="item">
            <i class="left arrow icon"></i>
            <span class="mobile hidden">{{ date('Y-m', date - 86400)}}</span>
          </a>
          {% else %}
          <a href="/labs/author?date={{ date('Y-m-d', date - 86400)}}{{ grouping ? '&grouping=' ~ grouping : '' }}" class="item">
            <i class="left arrow icon"></i>
            <span class="mobile hidden">{{ date('Y-m-d', date - 86400)}}</span>
          </a>
          {% endif %}
          <a class="item" href="/labs/author?date={{ date('Y-m-d')}}">
            Jump to Today
          </a>
          <div class="ui dropdown item">
            {{ (grouping ? grouping : 'Daily') | capitalize }}
            <i class="dropdown icon"></i>
            <div class="menu">
              <a class="{{ grouping == 'daily' ? 'active' : '' }} item" href="/labs/author">
                Daily
              </a>
              <a class="{{ grouping == 'monthly' ? 'active' : '' }} item" href="/labs/author?grouping=monthly">
                Monthly
              </a>
            </div>
          </div>
          <div class="right menu">
            {% if grouping %}
            <?php if(date('Y-m', $date) == date('Y-m')): ?>
            <a class="disabled item">
              <span class="mobile hidden">{{ date('Y-m', date + 86400 * 31)}}</span>
              <i class="right arrow icon"></i>
            </a>
            <?php else: ?>
            <a href="/labs/author?date={{ date('Y-m', date + 86400 * 31)}}{{ grouping ? '&grouping=' ~ grouping : '' }}" class="item">
              <span class="mobile hidden">{{ date('Y-m', date + 86400 * 31)}}</span>
              <i class="right arrow icon"></i>
            </a>
            <?php endif ?>
            {% else %}
              <?php if($date > time() - 86400): ?>
              <a class="disabled item">
                <span class="mobile hidden">{{ date('Y-m-d', date + 86400)}}</span>
                <i class="right arrow icon"></i>
              </a>
              <?php else: ?>
              <a href="/labs/author?date={{ date('Y-m-d', date + 86400)}}{{ grouping ? '&grouping=' ~ grouping : '' }}" class="item">
                <span class="mobile hidden">{{ date('Y-m-d', date + 86400)}}</span>
                <i class="right arrow icon"></i>
              </a>
              <?php endif ?>
            {% endif %}
          </div>
        </div>
        <div class="ui attached basic segment">
          <div class="ui small center aligned header">
            Totals (based on {{leaderboard | length}} authors)
          </div>
          <div class="ui divided grid">
            <div class="four column row">
              <div class="center aligned column">
                <div class="ui header">
                  {{ totals['steem'] }}
                  <div class="sub header">
                    STEEM
                  </div>
                </div>
              </div>
              <div class="center aligned column">
                <div class="ui header">
                  {{ totals['sbd'] }}
                  <div class="sub header">
                    SBD
                  </div>
                </div>
              </div>
              <div class="center aligned column">
                <div class="ui header">
                  {{ totals['sp'] }}
                  <div class="sub header">
                    Steem Power
                  </div>
                </div>
              </div>
              <div class="center aligned column">
                <div class="ui header">
                  <?php echo $this->largeNumber::format($totals['vest']); ?>
                  <div class="sub header">
                    VEST
                  </div>
                </div>
              </div>
            </div>
          </div>

        </div>
        <div class="ui bottom attached segment">
          <div class="ui header">
            Author Leaderboard for
            {% if grouping %}
              {{ date('Y-m', date) }}
            {% else %}
              {{ date('Y-m-d', date) }}
            {% endif %}
            (Displaying Top 500)
            <div class="sub header">
              The accounts earning the highest author rewards by day.
            </div>
          </div>
          <table class="ui celled table">
            <thead>
              <tr>
                <th colspan="2"></th>
                <th colspan="5" class='center aligned'>Total</th>
                <th colspan="3" class='center aligned'>Posts</th>
                <th colspan="3" class='center aligned'>Replies</th>
              </tr>
              <tr>
                <th class="collapsing">#</th>
                <th>Account</th>
                <th class="collapsing center aligned">VESTS/SP</th>
                <th class="collapsing center aligned">STEEM</th>
                <th class="collapsing center aligned">SBD</th>
                <th class="collapsing center aligned">Posts<br/>/Replies</th>
                <th class="collapsing center aligned">SP/Post</th>
                <th class="collapsing center aligned">VESTS/SP</th>
                <th class="collapsing center aligned">STEEM</th>
                <th class="collapsing center aligned">SBD</th>
                <th class="collapsing center aligned">VESTS/SP</th>
                <th class="collapsing center aligned">STEEM</th>
                <th class="collapsing center aligned">SBD</th>
              </tr>
            </thead>
            <tbody></tbody>
          {% for account in leaderboard %}
            {% if loop.index > 500 %}{% continue %}{% endif %}
            <tr>
              <td>
                #{{ loop.index }}
              </td>
              <td>
                <a href="/@{{ account._id }}">
                  {{ account._id }}
                </a>
              </td>
              <td class="right aligned">
                <div class="ui <?php echo $this->largeNumber::color($account->vest)?> label" data-popup data-content="<?php echo number_format($account->vest, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                  <?php echo $this->largeNumber::format($account->vest); ?>
                </div>
                <br>
                <small>
                  ~<?php echo $this->convert::vest2sp($account->vest, ""); ?> SP*
                </small>
              </td>
              <td>
                {{ account.steem }}
              </td>
              <td>
                {{ account.sbd }}
              </td>
              <td>
                {{ account.posts }}/{{ account.replies }}
              </td>
              <td>
                ~<?php echo $this->convert::vest2sp($account->vest / $account->count, ""); ?>&nbsp;SP*
              </td>
              <td class="right aligned">
                <div class="ui <?php echo $this->largeNumber::color($account->postVest)?> label" data-popup data-content="<?php echo number_format($account->postVest, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                  <?php echo $this->largeNumber::format($account->postVest); ?>
                </div>
                <br>
                <small>
                  ~<?php echo $this->convert::vest2sp($account->postVest, ""); ?> SP*
                </small>
              </td>
              <td>
                {{ account.postSteem }}
              </td>
              <td>
                {{ account.postSbd }}
              </td>
              <td class="right aligned">
                <div class="ui <?php echo $this->largeNumber::color($account->replyVest)?> label" data-popup data-content="<?php echo number_format($account->replyVest, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                  <?php echo $this->largeNumber::format($account->replyVest); ?>
                </div>
                <br>
                <small>
                  ~<?php echo $this->convert::vest2sp($account->replyVest, ""); ?> SP*
                </small>
              </td>
              <td>
                {{ account.replySteem }}
              </td>
              <td>
                {{ account.replySbd }}
              </td>
            </tr>
          {% else %}
          <tr>
            <td colspan="10">
              <div class="ui message">
                No data for this date
              </div>
            </td>
          </tr>
          {% endfor %}
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

{% endblock %}

{% block scripts %}

{% endblock %}
