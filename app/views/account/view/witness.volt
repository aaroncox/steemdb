<h3 class="ui header">
  Witness Voting
  <div class="sub header">
    Snapshot of blockchain information cached <?php echo $this->timeAgo::mongo($account->scanned); ?>
  </div>
</h3>
<div class="ui top attached tabular menu">
  <a class="active item" data-tab="history">History</a>
  <a class="item" data-tab="received">Votes Received</a>
  <a class="item" data-tab="cast">Votes Cast</a>
</div>
<div class="ui bottom attached padded segment">
  <div class="ui active tab" data-tab="history">
    <div class="ui large header">
      @{{ account.name }}'s Witness History
      <div class="sub header">
        The most recent votes cast for {{ account.name }}
      </div>
    </div>
    <table class="ui table">
      <thead>
        <tr>
          <th class="three wide">When</th>
          <th class="two wide"></th>
          <th>Account</th>
          <th class="right aligned">Weight</th>
        </tr>
      </thead>
      <tbody>
      {% for vote in votes %}
        <tr>
          <td>
            <?php echo $this->timeAgo::mongo($vote->_ts); ?>
          </td>
          <td>
            {% if vote.approve %}
            <span class="ui purple label">
              Approved
            </span>
            {% else %}
            <span class="ui orange label">
              Unapproved
            </span>
            {% endif %}
          </td>
          <td>
            <a href="/@{{ vote.account }}">
              {{ vote.account }}
            </a>
          </td>
          <td class="right aligned">
            {{ partial("_elements/witness_vesting_shares", ['weight': vote['voter'][0].vesting_shares]) }}
          </td>
        </tr>
      {% endfor %}
      </tbody>
    </table>
  </div>
  <div class="ui tab" data-tab="received">
    <div class="ui large header">
      Who votes for {{ account.name }}
      <div class="sub header">
        {{ witnessing | length }} total accounts
      </div>
    </div>
    <div class="ui divided relaxed list">
      {% for voter in witnessing %}
      <div class="item">
        <div class="right floated content">
          {{ partial("_elements/witness_vesting_shares", ['weight': voter.weight]) }}
        </div>
        <a href="/@{{ voter.name }}">
          {{ voter.name }}
        </a>
      </div>
      {% else %}
      <div class="item">
        <p>This account has not received any witness votes.</p>
      </div>
      {% endfor %}
    </div>
  </div>
  <div class="ui tab" data-tab="cast">
    <div class="ui large header">
      Who {{ account.name }} is voting for
      <div class="sub header">
        {{ account.witness_votes | length }} of 30 votes used.
      </div>
    </div>
    <div class="ui divided relaxed list">
      {% for votee in account.witness_votes %}
      <div class="item">
        <a href="/@{{ votee }}">
          {{ votee }}
        </a>
      </div>
      {% else %}
      <div class="item">
        <div class="ui warning message">
          <p>This account has not voted for anyone as a witness.</p>
          <p><a href="https://steemit.com/~witnesses">Witnesses can be voted for here.</a></p>
        </div>
      </div>
      {% endfor %}
    </div>
  </div>
</div>
