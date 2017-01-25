<div class="row">
  <div class="column">
    <div class="ui breadcrumb">
        <a class="section" href="/forums">
          <i class="home icon"></i>
          Forums
        </a>
        {% if category_key %}
        <i class="right chevron icon divider"></i>
        <a class="section" href="/forums/{{ category_key }}">
          <i class="comments outline icon"></i>
          {{ categories[category]['boards'][category_key]['name'] }}
        </a>
        {% elseif not forums and tag %}
        <i class="right chevron icon divider"></i>
        <a class="section" href="/forums/tag/{{ tag }}">
          <i class="hashtag icon"></i>
          {{ tag }}
        </a>
        {% elseif not forums %}
        <i class="right chevron icon divider"></i>
        <a class="section" href="/forums/everything">
          Uncategorized/Everything
        </a>
        {% endif %}
        {% if posts %}
        <i class="right chevron icon divider"></i>
        <div class="active section">
          <i class="talk outline icon"></i>
          {{ posts[0].title }}
        </div>
        {% endif %}
      </div>
  </div>
</div>
