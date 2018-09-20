<div class="ui stackable grid">
  <div class="row">
    <div class="twelve wide column">
      <h3 class="ui header">
        Platform Leaderboard (30-Days)
        <div class="sub header">
          The most rewarded authors using the <strong>{{ app }}</strong> platform to create content.
        </div>
      </h3>
    </div>
  </div>
</div>

<table class="ui stackable definition table">
  <thead>
    <tr>
      <th class='collapsing'></th>
      <th>Date</th>
      <th>Posts</th>
      <th>SBD</th>
      <th>VESTS</th>
      <th>STEEM</th>
    </tr>
  </thead>
  <tbody>
  {% for item in leaderboard %}
  <tr>
    <td class='right aligned'>
      {{ loop.index }}
    </td>
    <td class="three wide">
      <div class="ui small header">
        <a href="/@{{ item._id['account'] }}">
          {{ item._id['account'] }}
        </a>
      </div>
    </td>
    <td class='right aligned'>
      <a href="/@{{ item._id['account'] }}/posts">
        {{ item.count }}
      </a>
    </td>
    <td class='right aligned'>
      <div class="ui small header">
        {{ item.sbd }} SBD
      </div>
    </td>
    <td class='right aligned'>
      <div class="ui small header">
        <?php echo $this->convert->vest2sp($item->vests, null) ?> SP
        <div class="sub header">
          {{ item.vests }} VESTS
        </div>
      </div>
    </td>
    <td class='right aligned'>
      {{ item.steem }} STEEM
    </td>
  </tr>
  {% else %}
  <tr>
    <td>
      No rewards found.
    </td>
  </tr>
  {% endfor %}
  </tbody>
</table>
