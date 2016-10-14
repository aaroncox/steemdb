<div class="ui three small secondary statistics">
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
<h3 class="ui header">
  Recent History
  <div class="sub header">
    All recent activity involving @{{ account.name }}.
  </div>
</h3>

<table class="ui stackable definition table">
  <thead></thead>
  <tbody>
  {% for item in activity %}
  <tr>
    <td class="three wide">
      <div class="ui small header">
        <?php echo $this->opName::string($item[1]['op'], $account) ?>
        <div class="sub header">
          <?php echo $this->timeAgo::string($item[1]['timestamp']); ?>
          <br><a href="/block/{{ item[1]['block' ]}}"><small style="color: #bbb">Block #{{ item[1]['block' ]}}</small></a>
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
