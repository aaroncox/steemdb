{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui hidden divider"></div>
<div class="ui container">
  <div class="ui vertically divided grid">
    <div class="row">
      <div class="column">
        <div class="ui large header">
          Block {{ current._id }}
          <div class="sub header">
            &#x21b3; Witnessed by
            <a href="/@{{ current.witness}} ">
              {{ current.witness}}
            </a>
            on
            {{ current.timestamp }}
          </div>
        </div>
      </div>
    </div>
    <div class="two column row">
      <div class="column">
        <a class="ui labeled icon button" href="/block/{{ current._id - 1 }}">
          <i class="left arrow icon"></i>
          Block #{{ current._id - 1 }}
        </a>
      </div>
      <div class="right aligned column">
        <a class="ui right labeled icon button" href="/block/{{ current._id + 1 }}">
          <i class="right arrow icon"></i>
          Block #{{ current._id + 1 }}
        </a>
      </div>
    </div>
    <div class="row">
      <div class="column">
        <div class="ui top attached tabular menu">
          {% if current.transactions | length %}
          <a class="active item" data-tab="op">Operations</a>
          <a class="item" data-tab="tx">Transactions</a>
          {% endif %}
          <a class="item" data-tab="block">Block Data</a>
          <a class="item" data-tab="json">JSON</a>
        </div>
        <div class="ui bottom attached padded segment">
          {% if current.transactions | length %}
          <div class="ui active tab" data-tab="op">
            <table class="ui table">
            {% for tx in current.transactions %}
              <tr>
                <td class="three wide">
                  <div class="ui small header">
                    <?php echo $this->opName::string($tx->operations[0]) ?>
                    <div class="sub header">
                      <?php echo $this->timeAgo::string($current->timestamp); ?>
                      <br><a href="/block/{{ current._id }}"><small style="color: #bbb">Block #{{ current._id }}</small></a>
                    </div>
                  </div>
                </td>
                <td>
                  {% include "_elements/definition_table" with ['data': tx.operations[0][1]] %}
                </td>
              </tr>
            {% endfor %}
            </table>
          </div>
          {% endif %}
          {% if current.transactions | length %}
          <div class="ui tab" data-tab="tx">
            <table class="ui definition table" style="table-layout: fixed">
              <tbody>
              {% for tx in current.transactions %}
              <tr>
                <td class="collapsing">
                  {{ loop.index0 }}
                </td>
                <td>{% include '_elements/definition_table' with ['data': tx] %}</td>
              </tr>
              {% endfor %}
              </tbody>
            </table>
            {% endif %}
          </div>
          <div class="ui tab" data-tab="block">
            {% include '_elements/definition_table' with ['data': current] %}
          </div>
          <div class="ui tab" data-tab="json">
<pre>
<?php echo json_encode($current->toArray(), JSON_PRETTY_PRINT); ?>
</pre>
          </div>
        </div>
      </div>
    </div>
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
