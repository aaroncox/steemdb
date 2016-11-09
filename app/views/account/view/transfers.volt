<div class="ui three item inverted menu">
  <a href="/@{{ account.name }}/transfers" class="{{ router.getActionName() == 'transfers' ? "active" : "" }} blue item">Transfers</a>
  <a href="/@{{ account.name }}/powerup" class="{{ router.getActionName() == 'powerup' ? "active" : "" }} blue item">Power Ups</a>
  <a href="/@{{ account.name }}/powerdown" class="{{ router.getActionName() == 'powerdown' ? "active" : ""}} blue item">Power Downs</a>
</div>
<h3 class="ui header">
  Transfers
  <div class="sub header">
    Transfers to and from @{{ account.name }} of both GOLOS and GBG.
  </div>
</h3>
<table class="ui table">
  <thead>
    <tr>
      <th>When</th>
      <th>From</th>
      <th>To</th>
      <th class="right aligned">Amount</th>
      <th>Type</th>
    </tr>
  </thead>
  <tbody>
    {% for transfer in transfers %}
    <tr>
      <td>
        <div class="sub header">
          <?php echo $this->timeAgo::mongo($transfer->_ts); ?>
          <br><a href="/block/<?= explode("/", (string) $transfer->_id)[0] ?>"><small style="color: #bbb">Block #<?= explode("/", (string) $transfer->_id)[0] ?></small></a>
        </div>
      </td>
      <td>
        <a href="/@{{ transfer.from }}/transfers">
          {{ transfer.from }}
        </a>
      </td>
      <td>
        <a href="/@{{ transfer.to }}/transfers">
          {{ transfer.to }}
        </a>
      </td>
      <td class="right aligned">
        <div class="ui small header">
          <?php echo number_format($transfer->amount, 3, ".", ",") ?>
        </div>
      </td>
      <td class="right aligned">
        <div class="ui small header">
          {{ transfer.type }}
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
{% include "_elements/paginator.volt" %}
