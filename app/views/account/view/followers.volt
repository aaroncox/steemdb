<h3 class="ui dividing header">
  @{{ account.name }}'s followers
  <div class="sub header">
    Newest followers displayed first
  </div>
</h3>
<table class="ui table">
  <thead>
    <tr>
      <th class="three wide">When</th>
      <th>Account</th>
      <th class="collapsing">What</th>
    </tr>
  </thead>
  <tbody>
  {% for current in followers %}
    <tr>
      <td>
        <?php echo $this->timeAgo::mongo($current->_ts); ?>
      </td>
      <td>
        <a href="/@{{ current.follower }}">
          {{ current.follower }}
        </a>
      </td>
      <td>
        {{ (current.what[0]) ? current.what[0] : "unfollow" }}
      </td>
    </tr>
  {% else %}
    <tr>
      <td colspan="10">
        <div class="ui centered header">
          No accounts found
          <div class="sub header">
            SteemDB has no record of any accounts following this user.
          </div>
        </div>
      </td>
    </tr>
  {% endfor %}
  </tbody>
</table>
