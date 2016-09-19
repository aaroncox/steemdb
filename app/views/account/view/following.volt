<h3 class="ui dividing header">
  @{{ account.name }} is following
  <div class="sub header">
    Sorted by total vests
  </div>
</h3>
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
  {% for current in following %}
    {% include '_elements/account_table_row' with ['current': current] %}
  {% else %}
    <tr>
      <td>
        <div class="ui centered header">
          No accounts found
          <div class="sub header">
            SteemDB has no record of this account following any users.
          </div>
        </div>
      </td>
    </tr>
  {% endfor %}
  </tbody>
</table>
