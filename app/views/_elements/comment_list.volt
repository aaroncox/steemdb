<div class="ui internally celled stackable grid">
  {% for comment in comments %}
    <div class="row">
      <div class="one wide mobile hidden column">
        <div class="ui small center aligned header">
          <svg height="16" enable-background="new 0 0 33 33" version="1.1" viewBox="0 0 33 33" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Chevron_Up_Circle"><circle cx="16" cy="16" r="15"  style="fill: #4ba2f2; stroke: #4ba2f2;"></circle><path d="M16.699,11.293c-0.384-0.38-1.044-0.381-1.429,0l-6.999,6.899c-0.394,0.391-0.394,1.024,0,1.414 c0.395,0.391,1.034,0.391,1.429,0l6.285-6.195l6.285,6.196c0.394,0.391,1.034,0.391,1.429,0c0.394-0.391,0.394-1.024,0-1.414 L16.699,11.293z" fill="#fff"></path></g></svg>
          {{ comment.net_votes }}
          <div class="sub header">#{{ loop.index }}</div>
        </div>
      </div>
      <div class="twelve wide column">
        <div class="ui large header">
          <a href="{{ comment.url }}" style="color: #555">
            {{ comment.title }}
          </a>
          <div class="sub header">
            <span class="ui circular label" style="margin-left: 0">
              <?php echo $this->reputation::number($comment->author_reputation) ?>
            </span>
            <a href="/@{{ comment.author }}">
              {{ comment.author }}
            </a>
            in
            {% if sort is defined and date is defined %}
            <a href="/posts/{{ comment.category }}/{{ sort ? sort : 'earnings' }}/{{ date('Y-m-d', date)}}">
              #{{ comment.category }}
            </a>
            {% else %}
            <a href="/posts/{{ comment.category }}/earnings/{{ date('Y-m-d') }}">
              #{{ comment.category }}
            </a>
            {% endif %}
            <span class="mobile hidden">&mdash;</span>
            <br class="mobile visible">
            <span class="ui small left floated green header mobile visible">
              ${{ comment.total_payout_value }}
              <span class="sub header">
                (+<?php echo $this->largeNumber::format($comment->pending_payout_value); ?> Pending)
              </span>
            </span>

            <?php echo $this->timeAgo::mongo($comment->created); ?>
          </div>
        </div>
      </div>
      <div class="three wide center mobile hidden aligned column">
        <div class="ui green header">
          ${{ comment.total_payout_value }}
          <div class="sub header">
            +<?php echo $this->largeNumber::format($comment->pending_payout_value); ?> Pending
          </div>
        </div>
      </div>
    </div>
  {% else %}
    <div class="row">
      <div class="center aligned column">
        <div class="ui message">
          <div class="header">No posts found</div>
        </div>
      </div>
    </div>
  {% endfor %}
</div>
