<div class="ui stackable grid">
  <div class="row">
    {% if hide_count is not defined %}
    <div class="seven wide column mobile hidden">
      Page {{ page }} of {{ pages }}
    </div>
    {% endif %}
    <div class="right aligned nine wide column">
      <div class="ui small pagination menu">
        {% if page <= 1 %}
        <a class="paginate_button item previous disabled" href="#" tabindex="0">
        {% else %}
        <a class="paginate_button item previous" href="?page={{ page - 1 }}" tabindex="0">
        {% endif %}
          Previous
        </a>
        {% if page > 3 %}
        <a class="paginate_button item" href="?page=1" tabindex="0">
          1
        </a>
        {% endif %}
        {% if page - 2 > 0 %}
        <a class="paginate_button mobile hidden item" href="?page={{ page - 2}}" tabindex="0">
          {{ page - 2}}
        </a>
        {% endif %}
        {% if page - 1 > 0 %}
        <a class="paginate_button item" href="?page={{ page - 1}}" tabindex="0">
          {{ page - 1}}
        </a>
        {% endif %}
        <a class="paginate_button item active" href="?page={{ page }}" tabindex="0">
          {{ page }}
        </a>
        {% if page + 1 <= pages %}
        <a class="paginate_button item" href="?page={{ page + 1}}" tabindex="0">
          {{ page + 1}}
        </a>
        {% endif %}
        {% if page + 2 <= pages %}
        <a class="paginate_button mobile hidden item" href="?page={{ page + 2}}" tabindex="0">
          {{ page + 2}}
        </a>
        {% endif %}
        {% if page + 3 <= pages %}
        <a class="paginate_button mobile hidden item" href="?page={{ page + 3}}" tabindex="0">
          {{ page + 3}}
        </a>
        {% endif %}
        {% if page + 1 <= pages %}
        <a class="paginate_button item next" id="example_next" href="?page={{ page + 1 }}" tabindex="0">
          Next
        </a>
        {% endif %}
      </div>
    </div>
  </div>
</div>
