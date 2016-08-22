<svg width="100%" height="200px" id="account-votes"></svg>
<table class="ui table">
  <thead>
    <tr>
      <th>When</th>
      <th>Who/What</th>
      <th>Weight</th>
    </tr>
  </thead>
  <tbody>
    {% for vote in votes %}
    <tr>
      <td class="collapsing">
        <?php echo $this->timeAgo::mongo($vote->_ts); ?>
      </td>
      <td class="twelve wide">
        <div class="ui small header">
          <a href="/tag/@{{ vote.author }}/{{ vote.permlink }}">
            {{ vote.permlink }}
          </a>
          <div class="sub header">
            by
            <a href="/@{{ vote.author }}">
              {{ vote.author }}
            </a>
          </div>
        </div>
      </td>
      <td class="collapsing">
        {% if vote.weight > 0 %}
        <span class="ui green label">
        {% elseif vote.weight < 0 %}
        <span class="ui red label">
        {% else %}
        <span class="ui label">
        {% endif %}
          <?= round($vote->weight / 100) ?>%
        </span>
      </td>
    </tr>
    {% else %}
    <tr>
      <td colspan="10">
        <div class="ui centered header">
          No votes found
          <div class="sub header">
            SteemDB has no record of any votes by this user.
          </div>
        </div>
      </td>
    </tr>
    {% endfor %}
  </tbody>
</table>
