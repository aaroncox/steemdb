<div class="ui small header">
  <a href="/tag/@{{ item[1]['op'][1]['author'] }}/{{ item[1]['op'][1]['permlink'] }}">
    <?= str_replace("-", " ", $item[1]['op'][1]['permlink']) ?>
  </a>
  <div class="sub header">
    <div class="ui small celled horizontal list">
      <span class="item">
        &#x21b3;
        by:
        <a href="/@{{ item[1]['op'][1]['author'] }}">
          @{{ item[1]['op'][1]['author'] }}
        </a>
      </span>
      <span class="item">
        voter:
        <a href="/@{{ item[1]['op'][1]['voter'] }}">
          @{{ item[1]['op'][1]['voter'] }}
        </a>
        ({{ item[1]['op'][1]['weight'] / 100 }}%)
      </span>
      <a class="item" href="https://steemit.com/tag/@{{ item[1]['op'][1]['author'] }}/{{ item[1]['op'][1]['permlink'] }}">
        steemit.com
      </a>
      <a class="item" href="/tag/@{{ item[1]['op'][1]['author'] }}/{{ item[1]['op'][1]['permlink'] }}/votes">
        all votes
      </a>
    </div>
  </div>
</div>
