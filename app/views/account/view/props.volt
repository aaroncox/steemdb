<h3 class="ui header">
  Witness Props History
  <div class="sub header">
    The history of the account's witness properties.
  </div>
</h3>
<table class="ui attached table">
  <thead>
    <tr>
      <th>Date</th>
      <th>Quote</th>
      <th>Base</th>
      <th>Bias</th>
      <th>Creation Fee</th>
      <th>BBD Interest</th>
      <th>Block Size</th>
    </tr>
  </thead>
  <tbody>
    {% for props in history %}
    <tr>
      <td>
        {{ props.created.toDateTime().format('Y-m-d') }}
      </td>
      <td>
        {{ props.bbd_exchange_rate.quote }}
      </td>
      <td>
        {{ props.bbd_exchange_rate.base }}
      </td>
      <td>
        {% if props.bbd_exchange_rate.quote != "1.000 BEX" %}
        <?php echo round((1 - 1/explode(" ", $props->bbd_exchange_rate->quote)[0]) * 100, 1) ?>%
        {% endif %}
      </td>
      <td>
        {{ props.props.account_creation_fee }}
      </td>
      <td>
        {{ props.props.bbd_interest_rate }}
      </td>
      <td>
        {{ props.props.maximum_block_size }}
      </td>
    </tr>
    {% endfor %}
  </tbody>
</table>
