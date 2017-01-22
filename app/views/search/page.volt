{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui hidden divider"></div>
<div class="ui container">
  <div class="ui vertically divided grid">
    <div class="row">
      <div class="column">
        <form method="get" class="ui form">
          <div class="ui field">
            <input type="text" name="q" value="{{ q | e }}">
          </div>
          <input type="submit">
        </form>
      </div>
    </div>
    <div class="row">
      <div class="column">
        {% for result in results %}
          <div class="ui segment">
            <p>{{ result.title }}</p>
            <?php echo $this->timeAgo::mongo($result->created); ?>
          </div>
        {% endfor %}
      </div>
    </div>
  </div>
</div>

{% endblock %}

{% block scripts %}
{% endblock %}
