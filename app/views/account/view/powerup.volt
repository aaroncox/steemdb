<div class="ui three item inverted menu">
  <a href="/@{{ account.name }}/transfers" class="{{ router.getActionName() == 'transfers' ? "active" : "" }} blue item">Transfers</a>
  <a href="/@{{ account.name }}/powerup" class="{{ router.getActionName() == 'powerup' ? "active" : "" }} blue item">Power Ups</a>
  <a href="/@{{ account.name }}/powerdown" class="{{ router.getActionName() == 'powerdown' ? "active" : ""}} blue item">Power Downs</a>
</div>
<h3 class="ui dividing header">
  Power Ups
  <div class="sub header">
    The BEX powered up to @{{ account.name }}.
  </div>
</h3>
<table class="ui table">
  <thead>
    <tr>
      <th>When</th>
      <th>From</th>
      <th>To</th>
      <th class="right aligned">BEX</th>
    </tr>
  </thead>
  <tbody>
    {% for power in powerup %}
    <tr>
      <td>
        <?php echo $this->timeAgo::mongo($power->_ts); ?>
      </td>
      <td>
        <a href="/@{{ power.from }}">
          {{ power.from }}
        </a>
      </td>
      <td>
        <a href="/@{{ power.to }}">
          {{ power.to }}
        </a>
      </td>
      <td class="right aligned">
        {{ power.amount }} BEX
      </td>
    </tr>
  </tbody>
  {% else %}
  <tbody>
    <tr>
      <td colspan="10">
        <div class="ui header">
          No powerup transfers found
        </div>
      </td>
    </tr>
  </tbody>
  {% endfor %}
</table>
