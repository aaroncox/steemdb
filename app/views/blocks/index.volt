{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui body container">
  <div class="ui stackable grid">
    <div class="row">
      <div class="sixteen wide column">
        <h1 class="ui header">
          Recent Blocks
        </h1>
        <table class="ui table">
          <thead>
            <tr>
              <th class="collapsing">Height</th>
              <th class="three wide">Time</th>
              <th>Witness</th>
              <th class="collapsing">Transactions</th>
              <th class="collapsing">Operations</th>
            </tr>
          </thead>
          <tbody>
            {% for current in blocks %}
              <tr>
                <td>
                  <a href="/block/{{ current._id }}">
                    {{ current._id }}
                  </a>
                </td>
                <td>
                  {{ current._ts.toDateTime().format("Y-m-d H:i:s") }} UTC
                </td>
                <td>
                  <a href="/@{{ current.witness }}">
                    {{ current.witness }}
                  </a>
                </td>
                <td>
                  {{ current.transactions | length }}
                </td>
                <td>
                  <?php
                  $count = 0;
                  foreach(array_column($current->transactions, 'operations') as $ops) {
                    $count += count($ops);
                  } ?>
                  {{ count }}
                </td>
              </tr>
            {% endfor %}
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>


{% endblock %}
