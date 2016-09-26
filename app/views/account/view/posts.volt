<svg width="100%" height="200px" id="account-posts"></svg>
<div class="ui two tiny statistics">
  <div class="statistic">
    <div class="value">
      <?php echo number_format($total_payouts, 3, '.', ','); ?> SBD
    </div>
    <div class="label">
      Total Payouts
    </div>
  </div>
  <div class="statistic">
    <div class="value">
      <?php echo number_format($total_pending, 3, '.', ','); ?> SBD
    </div>
    <div class="label">
      Pending Payouts
    </div>
  </div>
</div>
<div class="ui horizontal header divider" style="margin: 1em 0">
  Root Posts
</div>
{% include "_elements/comment_list.volt" %}
