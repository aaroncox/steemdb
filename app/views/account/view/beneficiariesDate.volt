<h3 class="ui header">
  Beneficiary Rewards for {{ date }}
  <div class="sub header">
    The rewards @{{ account.name }} has earned from beneficiaries on {{ date }}.
  </div>
</h3>
<a href="/@{{ account.name }}/beneficiaries" class="ui primary icon button">
  <i class="left chevron icon"></i>
  Back to All Dates
</a>
<table class="ui striped table">
  <thead></thead>
  <tbody>
{% for reward in beneficiaries %}
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
        <div class="ui small header">
          <a href="/tag/@{{ reward.comment_author }}/{{ reward.comment_permlink }}">
            <?= str_replace("-", " ", $reward->comment_permlink) ?>
          </a>
          <div class="sub header">
            <div class="ui small celled horizontal list">
              <span class="item">
                &#x21b3;
                by:
                <a href="/@{{ reward.comment_author }}">
                  @{{ reward.comment_author }}
                </a>
              </span>
              <a class="item" href="https://steemit.com/tag/@{{ reward.comment_author }}/{{ reward.comment_permlink }}">
                steemit.com
              </a>
              <a class="item" href="/tag/@{{ reward.comment_author }}/{{ reward.comment_permlink }}/votes">
                all votes
              </a>
              <span class="item">
                <span data-popup data-content="{{ reward._ts.toDateTime().format("Y-m-d H:i:s") }} UTC" data-position="right center" data-variation="inverted">
                  <?php echo $this->timeAgo::mongo($reward->_ts); ?>
                </span>
              </span>
            </div>
          </div>
        </div>
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
