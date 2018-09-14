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
{% for reward in authoring %}
  {% if reward._ts.toDateTime().format("Ymd") != date %}
    {% if date != null %}
      </tbody>
    </table>
    {% endif %}
    <div class="ui header">
      {{ reward._ts.toDateTime().format("Y-m-d") }}
      {% set date = reward._ts.toDateTime().format("Ymd") %}
    </div>
    <table class="ui striped table">
      <thead>
        <tr>
          <th>Content</th>
          <th class="collapsing right aligned">BBD</th>
          <th class="collapsing right aligned">BEX</th>
          <th class="collapsing right aligned">BP</th>
          <th class="collapsing right aligned">VEST</th>
        </tr>
      </thead>
      <tbody class="infinite-scroll">
  {% endif %}
        <tr>
          <td>
            <a href="/tag/@{{ reward.author }}/{{ reward.permlink }}">
              {{ reward.permlink }}
            </a>
            <br>
            <?php echo $this->timeAgo::mongo($reward->_ts); ?>
          </td>
          <td class="collapsing right aligned">
            <?php echo $this->largeNumber::format($reward->bbd_payout); ?> BBD
          </td>
          <td class="collapsing right aligned">
            <?php echo $this->largeNumber::format($reward->dpay_payout); ?> BEX
          </td>
          <td class="collapsing right aligned">
            ~<?php echo $this->convert::vest2sp($reward->vesting_payout, ""); ?> BP*
          </td>
          <td class="collapsing right aligned">
            <div class="ui <?php echo $this->largeNumber::color($reward->vesting_payout)?> label" data-popup data-content="<?php echo number_format($reward->vesting_payout, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
              <?php echo $this->largeNumber::format($reward->vesting_payout); ?>
            </div>
          </td>
        </tr>
{% else %}
        <tr>
          <td colspan="10">
            <div class="ui header">
              No author rewards found
            </div>
          </td>
        </tr>
{% endfor %}
      </tbody>
    </table>
{% include "_elements/paginator.volt" %}
