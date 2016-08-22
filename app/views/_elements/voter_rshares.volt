{% if voter.rshares >= 1000000000000 %}
<div class="ui orange label">
{% elseif voter.rshares >= 10000000000 %}
<div class="ui purple label">
{% elseif voter.rshares >= 100000000 %}
<div class="ui blue label">
{% else %}
<div class="ui green label">
{% endif %}
    <?php echo $this->largeNumber::format($voter->rshares); ?>
</div>
