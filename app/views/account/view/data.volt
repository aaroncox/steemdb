<h3 class="ui dividing header">
  Account Raw Data
  <div class="sub header">
    Snapshot of blockchain information cached <?php echo $this->timeAgo::mongo($account->scanned); ?>
  </div>
</h3>
{% include '_elements/definition_table' with ['data': account] %}
