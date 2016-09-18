<small>
  Snapshot of blockchain information cached <?php echo $this->timeAgo::mongo($account->scanned); ?>
</small>
{% include '_elements/definition_table' with ['data': account] %}
