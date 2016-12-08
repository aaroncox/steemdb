<h3 class="ui header">
  Curation Rewards for {{ date }}
  <div class="sub header">
    The rewards @{{ account.name }} has earned from curation on {{ date }}.
  </div>
</h3>
<a href="/@{{ account.name }}/curation" class="ui primary icon button">
  <i class="left chevron icon"></i>
  Back to All Dates
</a>
<table class="ui striped table">
  <thead></thead>
  <tbody>
{% for reward in curation %}
    <tr>
      <td class="collapsing right aligned">
        <div class="ui <?php echo $this->largeNumber::color($reward->reward)?> label" data-popup data-content="<?php echo number_format($reward->reward, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
          <?php echo $this->largeNumber::format($reward->reward); ?>
        </div>
      </td>
      <td class="collapsing right aligned">
        ~<?php echo $this->convert::vest2sp($reward->reward, ""); ?> SP*
      </td>
      <td>
        <a href="/tag/@{{ reward.comment_author }}/{{ reward.comment_permlink }}">
          {{ reward.comment_permlink }}
        </a>
        <br>
        by <a href="/@{{ reward.comment_author }}">{{ reward.comment_author }}</a>,
        <span data-popup data-content="{{ reward._ts.toDateTime().format("Y-m-d H:i:s") }} UTC" data-position="right center" data-variation="inverted">
          <?php echo $this->timeAgo::mongo($reward->_ts); ?>
        </span>
      </td>
    </tr>
{% else %}
    <tr>
      <td colspan="10">
        <div class="ui header">
          No curation rewards found
        </div>
      </td>
    </tr>
{% endfor %}
  </tbody>
</table>
