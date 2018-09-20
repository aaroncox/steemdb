<div class="ui three item inverted menu">
  <a href="/@{{ account.name }}/authoring" class="{{ router.getActionName() == 'authoring' ? "active" : ""}} blue item">Author Rewards</a>
  <a href="/@{{ account.name }}/curation" class="{{ router.getActionName() == 'curation' ? "active" : "" }} blue item">Curation Rewards</a>
  <a href="/@{{ account.name }}/beneficiaries" class="{{ router.getActionName() == 'beneficiaries' ? "active" : "" }} blue item">Beneficiary Rewards</a>
</div>
<div class="ui stackable grid">
  <div class="row">
    <div class="seven wide column">
      <h3 class="ui header">
        Author Rewards
        <div class="sub header">
          The rewards @{{ account.name }} has earned from posting.
        </div>
      </h3>
      <a href="/@{{ account.name }}/authoring" class="ui tiny {{ filter == null ? 'blue' : '' }} basic button">All</a>
      <a href="/@{{ account.name }}/authoring?filter=posts" class="ui tiny {{ filter == 'posts' ? 'blue' : '' }} basic button">Only Posts</a>
      <a href="/@{{ account.name }}/authoring?filter=comments" class="ui tiny {{ filter == 'comments' ? 'blue' : '' }} basic button">Only Comments</a>
    </div>
    <div class="three wide center aligned column">
      <div class="ui segment">
        <div class="ui header">
        +<?php echo $this->largeNumber::format($stats[0]->day); ?>
        <div class="sub header">Last 24 hrs</div>
      </div>
      </div>
    </div>
    <div class="three wide center aligned column">
      <div class="ui segment">
        <div class="ui header">
        +<?php echo $this->largeNumber::format($stats[0]->week); ?>
        <div class="sub header">Last 7 Days</div>
      </div>
      </div>
    </div>
    <div class="three wide center aligned column">
      <div class="ui segment">
        <div class="ui header">
        +<?php echo $this->largeNumber::format($stats[0]->month); ?>
        <div class="sub header">Last 30 days</div>
      </div>
      </div>
    </div>
  </div>
</div>
<table class="ui striped sortable table">
  <thead>
    <tr>
      <th class="right aligned">Date</th>
      <th class="right aligned">Posts</th>
      <th class="right aligned">SBD</th>
      <th class="right aligned">STEEM</th>
      <th class="right aligned">VESTS Inc.</th>
      <th class="center aligned">Est. SP</th>
    </tr>
  </thead>
  <tbody>
    {% for reward in authoring %}
        <tr>
          <td class="collapsing right aligned">
            <a href="/@{{ account.name }}/authoring/{{ reward._ts.toDateTime().format("Y-m-d") }}{{ filter != null ? '?filter=' ~ filter : '' }}">
              {{ reward._ts.toDateTime().format("Y-m-d") }}
            </a>
          </td>
          <td class="collapsing right aligned">
            {{ reward.posts }}
          </td>
          <td class="collapsing right aligned">
            <?php echo $this->largeNumber::format($reward->sbd_payout); ?> SBD
          </td>
          <td class="collapsing right aligned">
            <?php echo $this->largeNumber::format($reward->steem_payout); ?> STEEM
          </td>
          <td class="collapsing right aligned">
            <div class="ui <?php echo $this->largeNumber::color($reward->reward)?> label" data-popup data-content="<?php echo number_format($reward->reward, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
              <?php echo $this->largeNumber::format($reward->vesting_payout); ?>
            </div>
          </td>
          <td class="collapsing right aligned">
            ~<?php echo $this->convert::vest2sp($reward->vesting_payout, ""); ?> SP*
          </td>
        </tr>
    {% else %}
        <tr>
          <td colspan="10">
            <div class="ui header">
              No curation rewards found
            </div>
          </td>
        </tr>
    {% endfor %}
  </tbody>
</table>
