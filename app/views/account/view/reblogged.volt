<h3 class="ui header">
  @{{ account.name }}'s content reblogged by others
  <div class="sub header">
    The content that @{{ account.name }} has created, and reblogged by others
  </div>
</h3>
<table class="ui table">
  <thead>
    <tr>
      <th class="collapsing">Date</th>
      <th>Author</th>
      <th>Content</th>
    </tr>
  </thead>
  <tbody>
    {% for reblog in reblogs %}
    <tr>
      <td class="collapsing">
        <?php echo $this->timeAgo::mongo($reblog->_ts); ?>
      </td>
      <td>
        <a href="/@{{ reblog.account }}">
          {{ reblog.account }}
        </a>
      </td>
      <td>
        <a href="/tag/@{{ reblog.author }}/{{ reblog.permlink }}">
          {{ reblog.permlink }}
        </a>
      </td>
    </tr>
  </tbody>
  {% else %}
  <tbody>
    <tr>
      <td colspan="10">
        <div class="ui header">
          No reblogs recorded
        </div>
      </td>
    </tr>
  </tbody>
  {% endfor %}
</table>
{% if reblogs | length == 100 and reblogs | length > 0 %}
<a href="?page={{ page + 1 }}" class="ui fluid primary button">
  Next Page
</a>
{% endif %}
