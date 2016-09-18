<div class="ui large card">
  <div class="content">
    <div class="header">
      <span class="ui circular blue tiny label" style="margin-left: 0; vertical-align: top;">
        <?php echo $this->reputation::number($account->reputation) ?>
      </span>
      <a href="/@{{ account.name }}">
        {{ account.name }}
      </a>
    </div>
    <div class="meta">
      joined <?php echo $this->timeAgo::mongo($account->created); ?>
      </a>
    </div>
<!--
    <div class="description">
    </div>
 -->
  </div>
  <div class="extra content">
    <span class="right floated">
      {{ account.following | length }} Following
    </span>
    <span>
      <i class="user icon"></i>
      {{ account.followers | length }} Followers
    </span>
  </div>
</div>
