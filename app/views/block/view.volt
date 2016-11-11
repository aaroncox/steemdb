{% extends 'layouts/default.volt' %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui huge header">
          Block {{ current._id }}
          <div class="sub header">
            Witnessed by
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
    {% if current.transactions | length %}
    <div class="row">
      <div class="column">
        <div class="ui header">
          Transactions
        </div>
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
      </div>
    </div>
    {% endif %}
    <div class="row">
      <div class="column">
        <div class="ui header">
          Block Details
        </div>
        {% include '_elements/definition_table' with ['data': current] %}
      </div>
    </div>
  </div>
</div>
{% endblock %}
