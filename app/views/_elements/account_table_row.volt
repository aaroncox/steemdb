<tr>
  <td>
    <div class="ui header">
      <div class="ui circular blue label">
        <?php echo $this->reputation::number($current->reputation) ?>
      </div>
      {{ link_to("/@" ~ current.name, current.name) }}
    </div>
  </td>
  <td class="collapsing">
    {{ current.followers_count }}
  </td>
  <td class="collapsing">
    {{ current.post_count }}
  </td>
  <td class="collapsing right aligned">
    {{ partial("_elements/vesting_shares", ['current': current]) }}
  </td>
</tr>
