<svg width="100%" height="200px" id="account-history"></svg>
<div class="ui three statistics">
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
<table class="ui table">
  <thead></thead>
  <tbody>
  {% for item in activity %}
  <tr>
    <td class="two wide">
      <div class="ui small header">
        {% if item[1]['op'][0] == 'account_create' %}
          Account Created
        {% elseif item[1]['op'][0] == 'account_update' %}
          Account Update
        {% elseif item[1]['op'][0] == 'account_witness_proxy' %}
          Witness Vote Proxy
        {% elseif item[1]['op'][0] == 'account_witness_vote' %}
          Witness Vote
        {% elseif item[1]['op'][0] == 'comment' %}
          {% if item[1]['op'][1]['author'] == account.name %}
            Post
          {% else %}
            Response
          {% endif %}

        {% elseif item[1]['op'][0] == 'comment_reward' %}
          Post Reward
        {% elseif item[1]['op'][0] == 'curate_reward' %}
          Curation Reward
        {% elseif item[1]['op'][0] == 'feed_publish' %}
          Feed Publish
        {% elseif item[1]['op'][0] == 'fill_vesting_withdraw' %}
          Power Down
        {% elseif item[1]['op'][0] == 'interest' %}
          Interest
        {% elseif item[1]['op'][0] == 'pow' %}
          Mining
        {% elseif item[1]['op'][0] == 'pow2' %}
          Mining
        {% elseif item[1]['op'][0] == 'transfer' %}
          Transfer
        {% elseif item[1]['op'][0] == 'transfer_to_vesting' %}
          Power Up
        {% elseif item[1]['op'][0] == 'vote' %}
          Vote
        {% elseif item[1]['op'][0] == 'witness_update' %}
          Witness Update
        {% else %}
          Unknown
        {% endif %}
        <div class="sub header">
          <?php echo $this->timeAgo::string($item[1]['timestamp']); ?>
        </div>
      </div>
    </td>
    <td>
      {% include "_elements/tx/" ~ item[1]['op'][0] %}
    </td>
  </tr>
  {% endfor %}
  </tbody>
</table>
