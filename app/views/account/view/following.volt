<h3 class="ui dividing header">
  @{{ account.name }} is following
  <div class="sub header">
    Most recently followed accounts displayed first
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
          {{ current.following }}
        </a>
      </td>
      <td>
        {{ (current.what[0]) ? current.what[0] : "unfollow" }}
      </td>
    </tr>
  {% endfor %}
  </tbody>
</table>
