<div class="ui card">
  <div class="content">
    <div class="header">
      <a href="/@{{ author.name }}">
        {{ author.name }}
      </a>
    </div>
    <div class="meta">
      <a>
        joined <?php echo $this->timeAgo::mongo($author->created); ?>
      </a>
    </div>
<!--
    <div class="description">
    </div>
 -->
  </div>
  <div class="extra content">
    <span class="right floated">
      {{ author.following | length }} Following
    </span>
    <span>
      <i class="user icon"></i>
      {{ author.followers | length }} Followers
    </span>
  </div>
</div>
