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
        <div class="ui segment">
          <div class="ui header">
            Current Experiments
            <div class="sub header">
              A list of the current experimental pages that really don't have a home.
            </div>
          </div>
          <div class="ui divider"></div>
          <div class="ui divided relaxed list">
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
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

{% endblock %}

{% block scripts %}
{% endblock %}
