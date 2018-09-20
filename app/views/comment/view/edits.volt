<h3 class="ui dividing header">Edit History</h3>
<div class="ui very relaxed divided list">
  {% for diff in edits %}
  <div class="ui header">
    Edit {{ diffs.length - loop.index0 + 1 }} - {{ diff._ts.toDateTime().format("Y-m-d H:i:s") }} UTC
  </div>
  <table class="ui definition table" style="table-layout: fixed">
    <tbody>
      <tr>
        <td class="two wide">Title</td>
        <td>{{ diff.title }}</td>
      </tr>
      <tr>
        <td class="two wide">Body</td>
        <td><pre>{{ diff.body }}</pre></td>
      </tr>
      <tr>
        <td class="two wide">JSON</td>
        <td>
<pre>
<?php echo json_encode(json_decode($diff->json_metadata, true), JSON_PRETTY_PRINT); ?>
</pre>
        </td>
      </tr>
    </tbody>
  </table>
  {% endfor %}
</div>
