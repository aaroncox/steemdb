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
<table class="ui striped table">
  <thead>
    <tr>
      <th>Content/Author</th>
      <th class="collapsing right aligned">VEST/SP</th>
    </tr>
  </thead>
  <tbody class="infinite-scroll">
    {% for reward in curation %}
    <tr>
      <td>
        <a href="/tag/@{{ reward.comment_author }}/{{ reward.comment_permlink }}">
          {{ reward.comment_permlink }}
        </a>
        <br>
        by <a href="/@{{ reward.comment_author }}">{{ reward.comment_author }}</a>, <?php echo $this->timeAgo::mongo($reward->_ts); ?>

      </td>
      <td class="collapsing right aligned">
        <div class="ui small header">
          <?php echo number_format($reward->reward, 3, ".", ",") ?> VESTS
          <div class="sub header">
            ~<?php echo $this->convert::vest2sp($reward->reward, ""); ?> SP*
          </div>
        </div>
      </td>
    </tr>
  </tbody>
  {% else %}
  <tbody>
    <tr>
      <td colspan="10">
        <div class="ui header">
          No author rewards found
        </div>
      </td>
    </tr>
  </tbody>
  {% endfor %}
</table>
{% include "_elements/paginator.volt" %}
