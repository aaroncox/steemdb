<div class="ui two item inverted menu">
  <a href="/@{{ account.name }}/authoring" class="{{ router.getActionName() == 'authoring' ? "active" : ""}} blue item">Author Rewards</a>
  <a href="/@{{ account.name }}/curation" class="{{ router.getActionName() == 'curation' ? "active" : "" }} blue item">Curation Rewards</a>
</div>
<div class="ui stackable grid">
  <div class="row">
    <div class="seven wide column">
      <h3 class="ui header">
        Curation Rewards
        <div class="sub header">
          The rewards @{{ account.name }} has earned from curation.
        </div>
      </h3>
    </div>
    <div class="three wide center aligned column">
      <div class="ui segment">
        <div class="ui header">
        +<?php echo $this->largeNumber::format($stats[0]->day); ?>
        <div class="sub header">1-Day</div>
      </div>
      </div>
    </div>
    <div class="three wide center aligned column">
      <div class="ui segment">
        <div class="ui header">
        +<?php echo $this->largeNumber::format($stats[0]->week); ?>
        <div class="sub header">7-Day</div>
      </div>
      </div>
    </div>
    <div class="three wide center aligned column">
      <div class="ui segment">
        <div class="ui header">
        +<?php echo $this->largeNumber::format($stats[0]->month); ?>
        <div class="sub header">30-day</div>
      </div>
      </div>
    </div>
  </div>
</div>
{% for reward in curation %}
  {% if reward._ts.toDateTime().format("Ymd") != date %}
    {% if date != null %}
      </tbody>
    </table>
    {% endif %}
    <div class="ui header">
      {{ reward._ts.toDateTime().format("Y-m-d") }}
      {% set date = reward._ts.toDateTime().format("Ymd") %}
    </div>
    <table class="ui striped table">
      <thead>
        <tr>
          <th>Content/Author</th>
          <th class="collapsing right aligned">VEST/SP</th>
        </tr>
      </thead>
      <tbody class="infinite-scroll">
  {% endif %}
        <tr>
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
          <td class="collapsing right aligned">
              <div class="ui <?php echo $this->largeNumber::color($reward->reward)?> label" data-popup data-content="<?php echo number_format($reward->reward, 3, ".", ",") ?> VESTS" data-variation="inverted" data-position="left center">
                <?php echo $this->largeNumber::format($reward->reward); ?>
              </div>
              <br>
              <small>
                ~<?php echo $this->convert::vest2sp($reward->reward, ""); ?> SP*
              </small>
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
{% include "_elements/paginator.volt" %}
