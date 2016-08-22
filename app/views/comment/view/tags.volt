<h3 class="ui dividing header">Tags</h3>
<div class="ui relaxed list">
  {% for tag in comment.metadata('tags') %}
  <div class="item">
    {{ tag }}
  </div>
  {% endfor %}
</div>
