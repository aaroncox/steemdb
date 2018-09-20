<div class="ui card">
  <div class="content">
    {#<img class="right floated avatar image" src="{{ live[0]['profile']['profile_image'] }}">#}
    <div class="header">
      <a href="/app/{{ app }}">
        {{ app }}
      </a>
    </div>
    {% if meta and meta['created'] %}
    <div class="meta">
      created <?php echo $this->timeAgo::mongo($meta[$app]['created']); ?>
    </div>
    {% endif %}
    {% if meta and meta['description'] %}
    <div class="description">
      {{ meta['description'] }}
    </div>
    {% endif %}
    {% if meta and meta['link'] %}
      <div class="description">
        <br><i class="linkify icon"></i>
        <a rel="nofollow noopener" href="{{ meta['link'] }}">
          {{ meta['link'] }}
        </a>
      </div>
    {% endif %}
  </div>
  {#<div class="extra content">
    <span class="right floated">
      {% if live[0] is defined and live[0] is defined and live[0]['profile'] is defined and live[0]['profile']['location'] is defined %}
        <i class="marker icon"></i>
        {{ live[0]['profile']['location'] }}
      {% endif %}
    </span>
    <span>
      <i class="users icon"></i>
      {{ account.followers | length }} Followers
    </span>
  </div>#}
</div>
