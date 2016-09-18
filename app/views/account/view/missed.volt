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
  {% endfor %}
</table>
