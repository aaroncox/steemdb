<table class="ui table">
  <thead>
    <tr>
      <th>%</th>
      <th>Voter</th>
      <th>Time</th>
      <th>Weight</th>
      <th>Round Shares</th>
    </tr>
  </thead>
  <tbody>
    {% for voter in votes %}
    <tr>
      <td>
        {{ voter.percent / 100 }}%
      </td>
      <td>
        <a href="/@{{ voter.voter }}">
          {{ voter.voter }}
        </a>
      </td>
      <td>
        {{ voter.time }}
      </td>
      <td>
        {% include "_elements/voter_weight.volt" %}
      </td>
      <td>
        {% include "_elements/voter_rshares.volt" %}
      </td>
    </tr>
  </tbody>
  {% endfor %}
</table>
