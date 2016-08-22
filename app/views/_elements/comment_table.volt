<table class="ui table">
  <thead>
    <tr>
      <th>When</th>
      <th>What</th>
      <th>Who</th>
      <th>Votes</th>
      <th>Earnings</th>
    </tr>
  </thead>
  <tbody>
    {% for comment in comments %}
      <tr>
        <td>
          {{ comment.created.toDateTime().format('Y-m-d H:i') }}
        </td>
        <td>
          <a href="{{ comment.url }}">
            {{ comment.title }}
          </a>
        </td>
        <td>
          <a href="/@{{ comment.author }}">
            {{ comment.author }}
          </a>
        </td>
        <td>
          {{ comment.net_votes }}
        </td>
        <td>
          {{ comment.total_payout_value }}
        </td>
      </tr>
    {% endfor %}
  </tbody>
</table>
