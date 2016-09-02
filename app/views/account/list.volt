{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<div class="ui vertical stripe segment">
  <div class="ui middle aligned stackable grid container">
    <div class="row">
      <div class="column">
        <div class="ui secondary menu">
          <a class="{{ filter == '' ? 'active' : '' }} item" href="/accounts">
            Vests
          </a>
          <a class="{{ filter == 'posts' ? 'active' : '' }} item" href="/accounts/posts">
            Posts
          </a>
          <a class="{{ filter == 'followers' ? 'active' : '' }} item" href="/accounts/followers">
            Followers
          </a>
          <a class="{{ filter == 'reputation' ? 'active' : '' }} item" href="/accounts/reputation">
            Reputation
          </a>
          <div class="right menu">
          </div>
        </div>
        <table class="ui table">
          <thead>
            <tr>
              <th>Account</th>
              <th>Followers</th>
              <th>Posts</th>
              <th>Vests</th>
            </tr>
          </thead>
          <tbody>
            {% for account in accounts %}
            <tr>
              <td>
                <div class="ui header">
                  <div class="ui circular blue label">
                    <?php echo $this->reputation::number($account->reputation) ?>
                  </div>
                  {{ link_to("/@" ~ account.name, account.name) }}
                </div>
              </td>
              <td class="collapsing">
                {{ account.followers | length }}
              </td>
              <td class="collapsing">
                {{ account.post_count }}
              </td>
              <td class="collapsing right aligned">
                {{ partial("_elements/vesting_shares", ['current': account]) }}
              </td>
            </tr>
            {% endfor %}
          </tbody>
        </table>
        {% include "_elements/paginator.volt" %}
      </div>
    </div>
  </div>
</div>
{% endblock %}
