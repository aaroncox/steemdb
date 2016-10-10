<div class="ui three item inverted menu">
  <a href="/@{{ account.name }}/transfers" class="{{ router.getActionName() == 'transfers' ? "active" : "" }} blue item">Transfers</a>
  <a href="/@{{ account.name }}/powerup" class="{{ router.getActionName() == 'powerup' ? "active" : "" }} blue item">Power Ups</a>
  <a href="/@{{ account.name }}/powerdown" class="{{ router.getActionName() == 'powerdown' ? "active" : ""}} blue item">Power Downs</a>
</div>
<h3 class="ui dividing header">
  Power Downs
  <div class="sub header">
    The VESTS/SP of @{{ account.name }} converted to liquid STEEM.
  </div>
</h3>
<table class="ui table">
  <thead>
    <tr>
      <th>When</th>
      <th>From</th>
      <th>To</th>
      <th class="right aligned">SP</th>
      <th class="right aligned">STEEM</th>
    </tr>
  </thead>
  <tbody>
    {% for power in powerdown %}
    <tr>
      <td>
        <?php echo $this->timeAgo::mongo($power->_ts); ?>
      </td>
      <td>
        <a href="/@{{ power.from_account }}">
          {{ power.from_account }}
        </a>
      </td>
      <td>
        <a href="/@{{ power.to_account }}">
          {{ power.to_account }}
        </a>
      </td>
      <td class="right aligned">
        <div class="ui small header">
          -<?php echo $this->largeNumber::format($power->withdrawn); ?>
        </div>
      </td>
      <td class="right aligned">
        <div class="ui small header">
          +<?php echo $power->deposited; ?> STEEM
        </div>
      </td>
    </tr>
  </tbody>
  {% else %}
  <tbody>
    <tr>
      <td colspan="10">
        <div class="ui header">
          No powerdown transfers found
        </div>
      </td>
    </tr>
  </tbody>
  {% endfor %}
</table>
