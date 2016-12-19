<table class="ui small definition table">
  <tbody>
    <tr>
      <td>Earnings</td>
      <td>${{ comment.total_payout_value }}</td>
    </tr>
    <tr>
      <td>Pending</td>
      <td>EST <?php echo $this->largeNumber::format($comment->total_pending_payout_value); ?></td>
    </tr>
  </tbody>
</table>
