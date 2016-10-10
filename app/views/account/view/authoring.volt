<div class="ui two item inverted menu">
  <a href="/@{{ account.name }}/authoring" class="{{ router.getActionName() == 'authoring' ? "active" : ""}} blue item">Author Rewards</a>
  <a href="/@{{ account.name }}/curation" class="{{ router.getActionName() == 'curation' ? "active" : "" }} blue item">Curation Rewards</a>
</div>
<h3 class="ui header">
  Author Rewards
  <div class="sub header">
    The rewards @{{ account.name }} has earned from posting.
  </div>
</h3>
<table class="ui striped table">
  <thead>
    <tr>
      <th>Content</th>
      <th class="collapsing right aligned">STEEM</th>
      <th class="collapsing right aligned">VEST/SP</th>
      <th class="collapsing right aligned">SBD</th>
    </tr>
  </thead>
  <tbody>
    {% for reward in authoring %}
    <tr>
      <td>
        <a href="/tag/@{{ reward.author }}/{{ reward.permlink }}">
          {{ reward.permlink }}
        </a>
        <br>
        <?php echo $this->timeAgo::mongo($reward->_ts); ?>
      </td>
      <td class="collapsing right aligned">
        <div class="ui small header">
          <?php echo $this->largeNumber::format($reward->steem_payout); ?> STEEM
        </div>
      </td>
      <td class="collapsing right aligned">
        <div class="ui small header">
          <?php echo number_format($reward->vesting_payout, 3, ".", ",") ?> VESTS
          <div class="sub header">
            ~<?php echo $this->convert::vest2sp($reward->vesting_payout, ""); ?> SP*
          </div>
        </div>
      </td>
      <td class="collapsing right aligned">
        <div class="ui small header">
          <?php echo $this->largeNumber::format($reward->sbd_payout); ?> SBD
        </div>
      </td>
    </tr>
  </tbody>
  {% else %}
  <tbody>
    <tr>
      <td colspan="10">
        <div class="ui header">
          No author rewards found
        </div>
      </td>
    </tr>
  </tbody>
  {% endfor %}
</table>
{% include "_elements/paginator.volt" %}
