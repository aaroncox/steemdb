<div class="ui divided relaxed  list">
  <div class="item">
    <strong>
      More posts by
      <a href="/@{{ comment.author }}">
        {{ comment.author }}
      </a>
    </strong>
  </div>
  {% for post in posts %}
    {% if post.url === comment.url %}
      {% continue %}
    {% endif %}
    <div class="item">
      <?php echo $this->timeAgo::mongo($post->created); ?><br>
      <a href="{{ post.url }}">
        {{ post.title }}
      </a>

    </div>
  {% endfor %}
</div>
