<div class="ui comments">
  <h3 class="ui dividing header">Replies</h3>
  {% for reply in replies %}
    {% include "comment/view/reply.volt" %}
  {% endfor %}
</div>
