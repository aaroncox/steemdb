{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<style>
  .tooltip {
  /* keep tooltips from blocking interactions */
  pointer-events: none;
}
</style>
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui huge header">
          SteemDB Labs
          <div class="sub header">
            Experimental projects and testing grounds for various concepts.
          </div>
        </div>
        <div class="ui segment">
          <div class="ui header">
            Active Experiments
            <div class="sub header">
              A list of the current experimental pages that really don't have a home on the site yet.
            </div>
          </div>
          <div class="ui divider"></div>
          <div class="ui divided relaxed list">
            <div class="item">
              <div class="ui header">
                <i class="list icon"></i>
                <div class="content">
                  <a href="/labs/pending">
                    Pending Payout Review
                  </a>
                  <div class="sub header">
                    Posts within their last 12hrslo where they can only receive downvotes.
                  </div>
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <i class="list icon"></i>
                <div class="content">
                  <a href="/labs/author">
                    Author Reward Leaderboard
                  </a>
                  <div class="sub header">
                    The highest earning authors per day.
                  </div>
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <i class="list icon"></i>
                <div class="content">
                  <a href="/labs/curation">
                    Curation Reward Leaderboard
                  </a>
                  <div class="sub header">
                    The highest earning curators per day.
                  </div>
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <i class="list icon"></i>
                <div class="content">
                  <a href="/labs/rshares">
                    rshare allocation by voter
                  </a>
                  <div class="sub header">
                    A day by day view of the voters who have contributed the most reward shares to all posts.
                  </div>
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <i class="list icon"></i>
                <div class="content">
                  <a href="/powerup">
                    biggest power ups
                  </a>
                  <div class="sub header">
                    The accounts who have powered up the most SP over the past 30 days.
                  </div>
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <i class="list icon"></i>
                <div class="content">
                  <a href="/labs/powerdown">
                    power down statistics
                  </a>
                  <div class="sub header">
                    Shows the largest accounts powering down as well as a week over week overview
                  </div>
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <i class="list icon"></i>
                <div class="content">
                  <a href="/labs/flags">
                    Account List by Flags Received
                  </a>
                  <div class="sub header">
                    Displays the top 200 most-flagged accounts
                  </div>
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <i class="list icon"></i>
                <div class="content">
                  <a href="/labs/conversions">
                    SBD Conversion History
                  </a>
                  <div class="sub header">
                    Most recent SBD -> STEEM Conversions
                  </div>
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <i class="list icon"></i>
                <div class="content">
                  <a href="/labs/clients">
                    Steem Client Usage
                  </a>
                  <div class="sub header">
                    Which steem clients are being used
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="ui segment">
          <div class="ui header">
            API Endpoints
            <div class="sub header">
              The available JSON endpoints available for consumption. Some of them are a bit slow. If you're looking to browse these with your browser, I'd recommend a <a href="https://github.com/tulios/json-viewer">json viewer</a>.
            </div>
          </div>
          <div class="ui divider"></div>
          <div class="ui divided relaxed list">
            <div class="item">
              <div class="ui header">
                <a href="/api/supply">
                  currency supply
                </a>
                <div class="sub header">
                  the sum of all balances in all accounts per day
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <a href="/api/props">
                  global props history
                </a>
                <div class="sub header">
                  a snapshot of the global properties of the blockchain every 6 hours
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <a href="/api/percentage">
                  percentage vesting
                </a>
                <div class="sub header">
                  the percentage of steem as vests
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <a href="/api/rshares">
                  voter rshares
                </a>
                <div class="sub header">
                  the reward shares allocated by voter, per day
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <a href="/api/downvotes">
                  downvoters
                </a>
                <div class="sub header">
                  the 20 most prolific downvoters per day
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <a href="/api/topwitnesses">
                  top 50 witnesses voters
                </a>
                <div class="sub header">
                  a list of the top 50 witnesses, each with details on the accounts voting for them
                </div>
              </div>
            </div>

            <div class="item">
              <div class="ui header">
                <a href="/api/rewards">
                  Daily Author Rewards (90-day)
                </a>
                <div class="sub header">
                  Daily totals of author rewards paid out over the last 90 days
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <a href="/api/curation">
                  Daily Curation Rewards (90-day)
                </a>
                <div class="sub header">
                  Daily totals of curation rewards paid out over the last 90 days
                </div>
              </div>
            </div>
            <div class="item">
              <div class="ui header">
                <a href="/api/topwitnesses">
                  STEEM -> VESTS per Day
                </a>
                <div class="sub header">
                  Total amount of STEEM powered up per day over the last 30 days
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

{% endblock %}

{% block scripts %}
{% endblock %}
