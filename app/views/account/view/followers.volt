<div class="ui divided relaxed list">
  {% for current in account.followers %}
    {% include '_elements/account_list_item.volt' %}
  {% else %}
    <div class="item">
      <div class="ui centered header">
        No accounts found
        <div class="sub header">
          SteemDB has no record of any accounts following this user.
        </div>
      </div>
    </div>
  {% endfor %}
</div>
