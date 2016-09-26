<h3 class="ui dividing header">Users Reblogging</h3>
<div class="ui very relaxed divided list">
  {% for reblog in reblogs %}
  <div class="item">
    <?php echo $this->timeAgo::mongo($reblog->_ts); ?>
    by
    <a href="/@{{ reblog.account }}">
      @{{ reblog.account }}
    </a>
  </div>
  {% endfor %}
</div>
