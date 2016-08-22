{% if current.vesting_shares >= 1000000000 %}
<div class="ui orange label">
{% elseif current.vesting_shares >= 10000000 %}
<div class="ui purple label">
{% elseif current.vesting_shares >= 100000 %}
<div class="ui blue label">
{% else %}
<div class="ui green label">
{% endif %}
    <?php echo $this->largeNumber::format($current->vesting_shares); ?> VEST
</div>
