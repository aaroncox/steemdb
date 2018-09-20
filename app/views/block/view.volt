{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui hidden divider"></div>
<div class="ui container">
  <div class="ui vertically divided grid">
    <div class="row">
      <div class="column">
        <div class="ui large header">
          Block {{ height }}
          <div class="sub header">
            {% if current %}
            &#x21b3; Witnessed by
            <a href="/@{{ current['witness']}} ">
              {{ current['witness']}}
            </a>
            on
            {{ current['timestamp'] }}
            {% else %}
            Unavailable
            {% endif %}
          </div>
        </div>
      </div>
    </div>
    <div class="two column row">
      <div class="column">
        <a class="ui labeled icon button" href="/block/{{ height - 1 }}">
          <i class="left arrow icon"></i>
          Block #{{ height - 1 }}
        </a>
      </div>
      <div class="right aligned column">
        {% if current %}
        <a class="ui right labeled icon button" href="/block/{{ height + 1 }}">
          <i class="right arrow icon"></i>
          Block #{{ height + 1 }}
        </a>
        {% endif %}
      </div>
    </div>
    {% if current %}
    <div class="row">
      <div class="column">
        <div class="ui top attached tabular menu">
          {% if current['transactions'] | length %}
          <a class="active item" data-tab="op">Operations</a>
          <a class="item" data-tab="tx">Transactions</a>
          <a class="item" data-tab="block">Block Data</a>
          {% else %}
          <a class="active item" data-tab="block">Block Data</a>
          {% endif %}
          <a class="item" data-tab="json">JSON</a>
        </div>
        <div class="ui bottom attached padded segment">
          {% if current['transactions'] | length %}
          <div class="ui active tab" data-tab="op">
            <table class="ui table">
            {% for idx, tx in current['transactions'] %}
              {% for op in tx['operations'] %}
              <tr>
                <td class="three wide">
                  <div class="ui small header">
                    <?php echo $this->opName::string($op) ?>
                    <div class="sub header">
                      <?php echo $this->timeAgo::string($current['timestamp']); ?>
                      <br><a href="/block/{{ height }}"><small style="color: #bbb">Block #{{ height }}</small></a>
                    </div>
                  </div>
                </td>
                <td>
                  {% include "_elements/definition_table" with ['data': op[1] + ['txid': current['transaction_ids'][idx]]] %}
                </td>
              </tr>
              {% endfor %}
            {% endfor %}
            </table>
          </div>
          {% endif %}
          {% if current['transactions'] | length %}
          <div class="ui tab" data-tab="tx">
            <table class="ui definition table" style="table-layout: fixed">
              <tbody>
              {% for tx in current['transactions'] %}
              <tr>
                <td class="collapsing">
                  {{ loop.index0 }}
                </td>
                <td>{% include '_elements/definition_table' with ['data': tx] %}</td>
              </tr>
              {% endfor %}
              </tbody>
            </table>
          </div>
          {% endif %}
          {% if not current['transactions'] | length %}
          <div class="ui active tab" data-tab="block">
          {% else %}
          <div class="ui tab" data-tab="block">
          {% endif %}
            {% include '_elements/definition_table' with ['data': current] %}
          </div>
          <div class="ui tab" data-tab="json">
<pre>
<?php echo json_encode($current, JSON_PRETTY_PRINT); ?>
</pre>
          </div>
        </div>
      </div>
    </div>
    {% else %}
    <div class="row">
      <div class="column">
        <div class="ui very padded center aligned segment">
          <div class="ui header">This block has not yet been imported into SteemDB. Refresh the page to try again.</div>
          <a href="/block/{{ height }}" class="ui primary button">Reload Page</a>
        </div>
      </div>
    </div>
    {% endif %}
  </div>
</div>
{% endblock %}

{% block scripts %}
  {% if chart is defined %}
    {% include 'charts/account/' ~ router.getActionName() %}
  {% endif %}
  <script>
    $('.tabular.menu .item')
      .tab({

      });
  </script>
{% endblock %}
