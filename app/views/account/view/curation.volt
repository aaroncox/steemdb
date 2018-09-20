<div class="ui three item inverted menu">
  <a href="/@{{ account.name }}/authoring" class="{{ router.getActionName() == 'authoring' ? "active" : ""}} blue item">Author Rewards</a>
  <a href="/@{{ account.name }}/curation" class="{{ router.getActionName() == 'curation' ? "active" : "" }} blue item">Curation Rewards</a>
  <a href="/@{{ account.name }}/beneficiaries" class="{{ router.getActionName() == 'beneficiaries' ? "active" : "" }} blue item">Beneficiary Rewards</a>
</div>
<div class="ui stackable grid">
  <div class="row">
    <div class="seven wide column">
      <h3 class="ui header">
        Curation Rewards
        <div class="sub header">
          The rewards @{{ account.name }} has earned from curation.
        </div>
      </h3>
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
      <th class="right aligned">Count</th>
      <th class="right aligned">VESTS Gained</th>
      <th>Estimated SP</th>
      <th class="right aligned">Acct % Increase</th>
      <th class="center aligned">Avg. SP/Vote</th>
    </tr>
  </thead>
  <tbody>
    {% for reward in curation %}
        <tr>
          <td class="collapsing right aligned">
            <a href="/@{{ account.name }}/curation/{{ reward._ts.toDateTime().format("Y-m-d") }}">
              {{ reward._ts.toDateTime().format("Y-m-d") }}
            </a>
          </td>
          <td class="collapsing right aligned">
            {{ reward.votes }}
          </td>
          <td class="collapsing right aligned">
            <div style="display: none"><?php echo number_format($reward->reward, 0, "", "") ?></div>
            <div class="ui <?php echo $this->largeNumber::color($reward->reward)?> label" data-popup data-content="<?php echo number_format($reward->reward, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
              <?php echo $this->largeNumber::format($reward->reward); ?>
            </div>
          </td>
          <td>
            ~<?php echo $this->convert::vest2sp($reward->reward, ""); ?> SP*
          </td>
          <td class="right aligned">
            <span style="color: #ccc">
              +<?php
                $percentage = (string) number_format($reward->reward / $account->vesting_shares * 100, 6, ".", "");
                $percentage_start = false;
                for($i = 0; $i <= strlen($percentage); $i++) {
                  if(isset($percentage[$i]) && is_numeric($percentage[$i]) && !in_array($percentage[$i], ['0']) && !$percentage_start) {
                    echo "<span style='color: #000'>";
                    $percentage_start = true;
                  }
                  echo $percentage[$i];
                }
              ?></span>%
            </span>
          </td>
          <td class="right aligned">
            ~<?php echo round($this->convert::vest2sp($reward->reward, false) / $reward->votes, 3); ?>
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
