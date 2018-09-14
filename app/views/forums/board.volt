{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui hidden divider"></div>
<div class="ui container">
  <div class="ui vertically divided grid">
    <div class="row">
      <div class="column">
        {% if forum is defined %}
        <div class="ui large header">
          {{ forum['name'] }}
          <div class="sub header">
            &#x21b3;
            {% if not forum['tags'] and not forum['accounts'] %}
            All posts
            {% endif %}
            {% for tag in forum['tags'] %}
              <a href="/forums/tag/{{ tag }}">
                #{{ tag }}
              </a>
            {% endfor %}
            {% for account in forum['accounts'] %}
              <a href="/@{{ account }}">
                @{{ account }}
              </a>
            {% endfor %}
          </div>
        </div>
        {% else %}
        <div class="ui large header">
          dPay Forums Prototype
          <div class="sub header">
            An experimental view of the dPay blockchain, organized in a traditional forum layout.
          </div>
        </div>
        {% endif %}
      </div>
    </div>
    {% include 'forums/_breadcrumb.volt' %}
    <div class="row">
      <div class="column">
        <table class="ui unstackable striped table">
          <thead>
            <tr>
              <th></th>
              <th>Topic</th>
              <th class="mobile hidden">Posts</th>
              <th class="mobile hidden">Latest Post</th>
            </tr>
          </thead>
          <tbody>
            {% for post in topics %}
            <tr>
              <td class="center aligned collapsing" data-popup data-content="Pending Payout: {{ post.pending_payout_value }} BBD" data-position="right center">
                {% if post.mode == 'archived' %}
                <i class="lock large bordered fitted icon"></i>
                {% elseif post.max_accepted_payout <= 0 %}
                  <i class="star large bordered fitted icon"></i>
                {% else %}
                  {% if post.pending_payout_value >= 100 %}
                  <i class="battery full large bordered fitted icon"></i>
                  {% elseif post.pending_payout_value >= 50 %}
                  <i class="battery high large bordered fitted icon"></i>
                  {% elseif post.pending_payout_value >= 10 %}
                  <i class="battery medium large bordered fitted icon"></i>
                  {% elseif post.pending_payout_value >= 1 %}
                  <i class="battery low large bordered fitted icon"></i>
                  {% else %}
                  <i class="battery empty large bordered fitted icon"></i>
                  {% endif %}
                {% endif %}
              </td>
              <td class="">
                <div class="ui header">
                  <a href="/forums{{ post.url }}">
                    {{ post.title }}
                  </a>
                  <div class="sub header">
                    by
                    <a href="/@{{ post.author }}">
                      {{ post.author }}
                    </a>
                    <?php echo $this->timeAgo::mongo($post->created); ?>
                    <span class="mobile hidden">
                      &mdash;
                      {% for tag in post.json_metadata.tags %}
                        <a href="/forums/tag/{{ tag }}">
                          #{{ tag }}
                        </a>
                      {% endfor %}
                    </span>
                    {% if post.last_reply %}
                    <div class="mobile visible">
                      <p>
                        last reply by
                        <a href="/@{{ post.last_reply_by }}">
                          {{ post.last_reply_by }}
                        </a>
                        <?php echo $this->timeAgo::mongo($post->last_reply); ?>
                      </p>
                    </div>
                    {% endif %}
                  </div>
                </div>
              </td>
              <td class="one wide center mobile hidden aligned">
                {{ post.children }}
              </td>
              <td class="two wide mobile hidden">
                {% if post.last_reply %}
                <p>
                  <a href="/@{{ post.last_reply_by }}">
                    {{ post.last_reply_by }}
                  </a>
                  <br>
                  <?php echo $this->timeAgo::mongo($post->last_reply); ?>
                </p>
                {% endif %}
              </td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
        {% include "_elements/paginator.volt" %}
      </div>
    </div>
    <div class="row">
      <div class="column">
        <div class="ui small header">
          Legend
        </div>
        <div class="ui divided horizontal list">
          <div class="item">
            <i class="lock icon"></i>
            <div class="content">
              Archived Post
            </div>
          </div>
          <div class="item">
            <i class="star icon"></i>
            <div class="content">
              Payout Declined
            </div>
          </div>
          <div class="item">
            <i class="battery empty icon"></i>
            <div class="content">
              Very Low Payout
            </div>
          </div>
          <div class="item">
            <i class="battery low icon"></i>
            <div class="content">
              Low Payout
            </div>
          </div>
          <div class="item">
            <i class="battery medium icon"></i>
            <div class="content">
              Medium Payout
            </div>
          </div>
          <div class="item">
            <i class="battery high icon"></i>
            <div class="content">
              Large Payout
            </div>
          </div>
          <div class="item">
            <i class="battery full icon"></i>
            <div class="content">
              Huge Payout
            </div>
          </div>
        </div>
      </div>
    </div>
    {% include 'forums/_breadcrumb.volt' %}
  </div>
</div>

{% endblock %}

{% block scripts %}
<script>
  $("[data-popup]").popup();
</script>
{% endblock %}
