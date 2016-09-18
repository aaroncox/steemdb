<svg width="100%" height="200px" id="account-history"></svg>
<div class="ui three small statistics">
  <div class="statistic">
    <div class="value">
      {{ account.followers | length }}
    </div>
    <div class="label">
      Followers
    </div>
  </div>
  <div class="statistic">
    <div class="value">
      {{ account.post_count }}
    </div>
    <div class="label">
      Posts
    </div>
  </div>
  <div class="statistic">
    <div class="value">
      {{ account.following | length }}
    </div>
    <div class="label">
      Following
    </div>
  </div>
</div>
<table class="ui stackable table">
  <thead></thead>
  <tbody>
  {% for item in activity %}
  <tr>
    <td class="two wide">
      <div class="ui small header">
        <?php echo $this->opName::string($item[1]['op'], $account) ?>
        <div class="sub header">
          <?php echo $this->timeAgo::string($item[1]['timestamp']); ?>
        </div>
      </div>
    </td>
    <td>
      {% include "_elements/tx/" ~ item[1]['op'][0] %}
    </td>
  </tr>
  {% else %}
  <tr>
    <td>
      Unable to connect to steemd for to load recent history.
    </td>
  </tr>
  {% endfor %}
  </tbody>
</table>
