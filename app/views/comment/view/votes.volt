<table class="ui unstackable table">
  <thead>
    <tr>
      <th class="mobile hidden">%</th>
      <th>Voter</th>
      <th class="mobile hidden">Time</th>
      <th class="mobile hidden">Weight</th>
      <th>Reward Shares</th>
    </tr>
  </thead>
  <tbody>
    {% for voter in votes %}
    <tr>
      <td class="mobile hidden">
        {{ voter.percent / 100 }}%
      </td>
      <td>
        <a href="/@{{ voter.voter }}">
          {{ voter.voter }}
        </a>
      </td>
      <td class="mobile hidden">
        {{ voter.time }}
      </td>
      <td class="mobile hidden">
        {% include "_elements/voter_weight.volt" %}
      </td>
      <td>
        {% include "_elements/voter_rshares.volt" %}
      </td>
    </tr>
  </tbody>
  {% endfor %}
</table>
