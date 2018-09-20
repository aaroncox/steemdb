<div class="ui three item inverted menu">
  <a href="/@{{ account.name }}/transfers" class="{{ router.getActionName() == 'transfers' ? "active" : "" }} blue item">Transfers</a>
  <a href="/@{{ account.name }}/powerup" class="{{ router.getActionName() == 'powerup' ? "active" : "" }} blue item">Power Ups</a>
  <a href="/@{{ account.name }}/powerdown" class="{{ router.getActionName() == 'powerdown' ? "active" : ""}} blue item">Power Downs</a>
</div>
<h3 class="ui header">
  Transfers
  <div class="sub header">
    Transfers to and from @{{ account.name }} of both STEEM and SBD.
  </div>
</h3>
<table class="ui table">
  <thead>
    <tr>
      <th>When</th>
      <th>From</th>
      <th>To</th>
      <th class="right aligned">Amount</th>
      <th class="left aligned">Type</th>
      <th>Memo</th>
    </tr>
  </thead>
  <tbody>
    {% for transfer in transfers %}
    <tr>
      <td class="collapsing">
        <?php echo gmdate("Y-m-d H:i:s e", (string) $transfer->_ts / 1000) ?>
      </td>
      <td>
        <a href="/@{{ transfer.from }}">
          {{ transfer.from }}
        </a>
      </td>
      <td>
        <a href="/@{{ transfer.to }}">
          {{ transfer.to }}
        </a>
      </td>
      <td class="right aligned">
        <div class="ui small header">
          <?php echo number_format($transfer->amount, 3, ".", ",") ?>
        </div>
      </td>
      <td class="left aligned">
        {{ transfer.type }}
      </td>
      <td class="collapsing">
        {% if transfer.memo %}
        <div class="ui icon mini button" data-popup data-content="{{ transfer.memo }}">
          <i class="sticky note outline icon"></i>
        </div>
        {% endif %}
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
