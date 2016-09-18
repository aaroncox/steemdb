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
        <div class="ui horizontal header divider">
          Transactions
        </div>
        {% for tx in current.transactions %}
          {% include '_elements/definition_table' with ['data': tx] %}
        {% endfor %}
      </div>
    </div>
  </div>
</div>
{% endblock %}
