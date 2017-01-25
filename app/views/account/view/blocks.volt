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
        <a href="/block/<?php echo $b->block ?>">
          <?php echo $b->block ?>
        </a>
      </td>
      <td class="collapsing">
        <?php echo gmdate("Y-m-d H:i:s e", (string) $b->_ts / 1000) ?>
      </td>
      <td>{{ b.work[1].input.worker_account }}</td>
    </tr>
  </tbody>
  {% endfor %}
</table>
