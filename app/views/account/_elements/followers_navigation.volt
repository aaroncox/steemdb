<div class="ui menu">
  <a href="/@{{ account.name }}/followers" class="{{ (active is defined and active == 'recent') ? 'active' : ''}} item">
    Recent
  </a>
  <a href="/@{{ account.name }}/followers/whales" class="{{ (active is defined and active == 'whales') ? 'active' : ''}} item">
    Account Size
  </a>
</div>
