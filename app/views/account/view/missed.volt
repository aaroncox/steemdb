<h3 class="ui dividing header">
  Missed Blocks
  <div class="sub header">
    Blocks that @{{ account.name }} has missed via witnessing
  </div>
</h3>
<table class="ui table">
  <thead>
    <tr>
      <th class="collapsing">Date</th>
      <th>Account Name</th>
    </tr>
  </thead>
  <tbody>
    {% for b in mining %}
    <tr>
      <td class="collapsing">
        <?php echo $this->timeAgo::mongo($b->date); ?>
      </td>
      <td>{{ b.witness }}</td>
    </tr>
  </tbody>
  {% else %}
  <tbody>
    <tr>
      <td colspan="10">
        <div class="ui header">
          No missing blocks recorded
        </div>
      </td>
    </tr>
  </tbody>
  {% endfor %}
</table>
