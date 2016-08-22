<div class="ui stackable grid container">
  <div class="row">
    <div class="eight wide column">
      <div class="ui header">
        <div class="sub header">
          {{ account.witness_votes | length }} of 30 votes used.
        </div>
        Who {{ account.name }} is voting for:
      </div>
      <div class="ui divided relaxed list">
        {% for votee in account.witness_votes %}
        <div class="item">
          <a href="@{{ votee }}">
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
    <div class="eight wide column">
      <div class="ui header">
        <div class="sub header">
          {{ witnessing | length }} total accounts
        </div>
        Who votes for {{ account.name }}:
      </div>
      <div class="ui divided relaxed list">
        {% for voter in witnessing %}
        <div class="item">
          <div class="right floated content">
            {{ partial("_elements/vesting_shares", ['current': voter]) }}
          </div>
          <a href="@{{ voter.name }}">
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
  </div>
</div>
