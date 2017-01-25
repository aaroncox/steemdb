<h3 class="ui header">
  Replies
  <div class="sub header">
    Posts that @{{ account.name }} has replied to
  </div>
</h3>
<div class="ui comments">
  {% for comment in replies %}
  <div class="ui segment">
    <div class="comment">
      <a class="avatar">
        <img src="https://steemstats.com/images/avatar.8418a25d.png">
      </a>
      <div class="content">
        <div class="author">
          Reply on
          <a href="/tag/@{{ comment.parent_author }}/{{ comment.parent_permlink }}">
            {{ comment.root_title }}
          </a>
          by
          <a href="/@{{ comment.parent_author }}">
            {{ comment.parent_author }}
          </a>
        </div>
        <div class="metadata">
          <span class="date">
            {{ comment.author }} responded on {{ comment.created.toDateTime().format('Y-m-d H:i') }}
          </span>
        </div>
        <div class="text">
          <p>
            {{ markdown(comment.body) }}
          </p>
        </div>
        <div class="actions">
          <a class="reply" href="https://steemit.com/tag/@{{ comment.author }}/{{ comment.permlink }}" target="_blank">
            View on Steemit / Reply
          </a>
          <a class="reply" href="https://steemdb.com/tag/@{{ comment.author }}/{{ comment.permlink }}" target="_blank">
            View on SteemDB 
          </a>
        </div>
      </div>
    </div>
  </div>
  {% endfor %}
</div>
