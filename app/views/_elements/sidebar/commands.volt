<table class="ui small table">
  <tbody>
    <tr>
      <td>
        <small>
        vote <strong>your-acct</strong> "{{ comment.author }}" "{{ comment.permlink }}" 100 true
        </small>
      </td>
    </tr>
    <tr>
      <td>
        <small>
        post_comment <strong>your-acct</strong> "re-{{ comment.author }}-{{ comment.permlink }}-<?php echo date("Ymd\\tHism\z") ?>" "{{ comment.author }}" "{{ comment.permlink }}" "" "your reply.." "{}" true
        </small>
      </td>
    </tr>
  </tbody>
</table>
<pre>
</pre>
