<div class="ui divided relaxed list">
  {% for current in account.following %}
    {% include '_elements/account_list_item.volt' %}
  {% else %}
    <div class="item">
      <div class="ui centered header">
        No accounts found
        <div class="sub header">
          SteemDB has no record of this account following any users.
        </div>
      </div>
    </div>
  {% endfor %}
</div>
