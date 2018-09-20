<div class="comment">
  <a class="avatar">
    <img src="https://steemstats.com/images/avatar.8418a25d.png">
  </a>
  <div class="content">
    <a class="author" href="/@{{ reply.author }}">
      {{ reply.author }}
    </a>
    <div class="metadata">
      <span class="date">
        <?php echo $this->timeAgo::mongo($reply->created); ?>
      </span>
    </div>
    <div class="text">
      {{ markdown(reply.body) }}
    </div>
    <div class="actions">
      <a class="reply" href="https://steemit.com/tag/@{{ reply.author }}/{{ reply.permlink }}" target="_blank">
        View on Steemit / Reply
      </a>
      <a class="reply" href="https://steemdb.com/tag/@{{ reply.author }}/{{ reply.permlink }}" target="_blank">
        View on SteemDB
      </a>
    </div>
  </div>
  {% if reply.children > 0 %}
  <div class="comments">
    {% for child in reply.getChildren() %}
      {% include "comment/view/reply" with ['reply': child] %}
    {% endfor %}
  </div>
  {% endif %}
</div>
