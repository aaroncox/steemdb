<h3 class="ui header">
  Blocks
  <div class="sub header">
    Blocks witnessed or mined by @{{ account.name }}.
  </div>
</h3>
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
        <a href="/block/{{ b._id }}">
          {{ b._id }}
        </a>
      </td>
      <td class="collapsing">
        <?php echo $this->timeAgo::mongo($b->_ts); ?>
      </td>
      <td>{{ b.witness }}</td>
    </tr>
  </tbody>
  {% endfor %}
</table>
