<h3 class="ui header">
  @{{ account.name }}'s followers
  <div class="sub header">
    Newest followers displayed first
  </div>
</h3>
{% include 'account/_elements/followers_navigation' with ['active': 'recent'] %}
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
        {% if current.what[0] !== "ignore" %}
          <div class="ui green label">
            Follow
          </div>
        {% else %}
          <div class="ui red label">
            Unfollow
          </div>
        {% endif %}
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
