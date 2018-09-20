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
        <div class="ui segment">
          <div class="ui divided very relaxed list">
            {% for result in results %}
              <div class="item">
                <div class="ui header">
                  <a href="{{ result.url }}">
                    {{ (result.title) ? result.title : result.root_title }}
                  </a>
                  <div class="sub header">
                    by
                    <a href="/@{{ result.author}}">
                      {{ result.author}}
                    </a>
                    &mdash;
                    <?php echo $this->timeAgo::mongo($result->created); ?>
                  </div>
                </div>
              </div>

            {% endfor %}
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

{% endblock %}

{% block scripts %}
{% endblock %}
