{% if voter.weight >= 10000000000000000 %}
<div class="ui orange label">
{% elseif voter.weight >= 100000000000000 %}
<div class="ui purple label">
{% elseif voter.weight >= 1000000000000 %}
<div class="ui blue label">
{% else %}
<div class="ui green label">
{% endif %}
  <?php echo $this->largeNumber::format($voter->weight); ?>
</div>
