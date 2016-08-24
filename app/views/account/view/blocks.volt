<svg width="100%" height="200px" id="account-mining"></svg>
<table class="ui table">
  <thead>
    <tr>
      <th class="collapsing">Block</th>
      <th class="collapsing">Date</th>
      <th>Account Name</th>
    </tr>
  </thead>
  <tbody>
    {% for b in mining %}
    <tr>
      <td class="collapsing">
        {{ b._id }}
      </td>
      <td class="collapsing">
        <?php echo $this->timeAgo::mongo($b->_ts); ?>
      </td>
      <td>{{ b.witness }}</td>
    </tr>
  </tbody>
  {% endfor %}
</table>
