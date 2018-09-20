<div class="ui stackable grid">
  <div class="row">
    <div class="seven wide column">
      <h3 class="ui header">
        Benefactor Rewards
        <div class="sub header">
          All recent earnings awarded to the <strong>{{ app }}</strong> platform.
        </div>
      </h3>
    </div>
    <div class="three wide center aligned column">
      <div class="ui segment">
        <div class="ui header">
          +<?php echo $this->largeNumber::format($this->convert->vest2sp($stats[0]->week, false), '') ?>&nbsp;SP
          <div class="sub header">Last Week</div>
        </div>
      </div>
    </div>
    <div class="three wide center aligned column">
      <div class="ui segment">
        <div class="ui header">
          +<?php echo $this->largeNumber::format($this->convert->vest2sp($stats[0]->month, false), '') ?>&nbsp;SP
          <div class="sub header">Last Month</div>
        </div>
      </div>
    </div>
    <div class="three wide center aligned column">
      <div class="ui segment">
        <div class="ui header">
          +<?php echo $this->largeNumber::format($this->convert->vest2sp($stats[0]->quarter, false), '') ?>&nbsp;SP
          <div class="sub header">Last Quarter</div>
        </div>
      </div>
    </div>
  </div>
</div>

<table class="ui stackable definition table">
  <thead>
    <tr>
      <th>Date</th>
      <th>Rewards</th>
      <th>Posts</th>
    </tr>
  </thead>
  <tbody>
  {% for item in rewards %}
  <tr>
    <td class="three wide">
      <div class="ui small header">
        {{ item._id['year']}}-{{ item._id['month']}}-{{ item._id['day']}}
      </div>
    </td>
    <td>
      <div class="ui small header">
        <?php echo $this->convert->vest2sp($item->reward, null) ?> SP
        <div class="sub header">
          {{ item.reward }} VESTS
        </div>
      </div>
    </td>
    <td>
      {{ item.count }}
    </td>
  </tr>
  {% else %}
  <tr>
    <td>
      No rewards found.
    </td>
  </tr>
  {% endfor %}
  </tbody>
</table>
