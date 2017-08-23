<div class="ui two item inverted menu">
  <a href="/@{{ account.name }}/votes?type=outgoing" class="{{ filter is not defined or filter is defined and filter == 'outgoing' ? "active" : "" }} blue item">Outgoing Votes</a>
  <a href="/@{{ account.name }}/votes?type=incoming" class="{{ filter is defined and filter == "incoming" ? "active" : ""}} blue item">Incoming Votes</a>
</div>
<table class="ui striped table">
  <tbody>
    {% for vote in votes %}
    <tr>
      <td class="center aligned collapsing">
        {% if vote.weight > 0 %}
        <span class="ui green label">
        {% elseif vote.weight < 0 %}
        <span class="ui red label">
        {% else %}
        <span class="ui label">
        {% endif %}
          <?= round($vote->weight / 100) ?>%
        </span>
        <br>
        <?php echo $this->timeAgo::mongo($vote->_ts); ?>
      </td>
      <td class="">
        <div class="ui small header">
            <a href="/@{{ vote.voter }}">
              @{{ vote.voter }}
            </a>
            voted on
          <div class="sub header">
            <a href="/tag/@{{ vote.author }}/{{ vote.permlink }}">
              {{ vote.permlink }}
            </a>
          </div>
          <div class="sub header">
            by
            <a href="/@{{ vote.author }}">
              {{ vote.author }}
            </a>
          </div>
        </div>
      </td>
      <td class="collapsing">
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
