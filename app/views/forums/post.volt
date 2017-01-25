{% extends 'layouts/default.volt' %}

{% block header %}

{% endblock %}

{% block content %}
<style>
.comment .markdown > * {
  font-size: 1em;
}
.comment .markdown code {
  white-space: pre;
  font-family: Consolas,Liberation Mono,Courier,monospace;
  display: block;
  padding: 10px;
  background: #f4f4f4;
  border-radius: 3px;
}
a.anchor {
    display: block;
    position: relative;
    top: -50px;
    visibility: hidden;
}
.ui.secondary.segment.quoted {
  position: relative;
}
.ui.secondary.segment.quoted.minimized {
  max-height: 210px;
  overflow: hidden;
}
.ui.secondary.segment.quoted .read-more {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  text-align: center;
  margin: 0; padding: 20px 0;
  /*background: #fff;*/
  background-image: linear-gradient(to bottom, transparent, #F3F4F5);
}
.ui.secondary.segment.quoted .read-more a {
}
</style>
<div class="ui hidden divider"></div>
<div class="ui container">
  <div class="ui vertically divided equal height grid">
    <div class="row stackable">
      <div class="thirteen wide column">
        <div class="ui large header">
          Create new post
          <div class="sub header">
            &#x21b3;
          </div>
          <div class="sub header" style="padding-left: 20px">
            <small>
              &#x21b3; in
            </small>
          </div>
        </div>
      </div>
      <div class="three wide column mobile hidden">
        <table class="ui small definition table">
          <tbody>
            <tr>
              <td>Votes</td>
              <td>{{ posts[0].net_votes }}</td>
            </tr>
            <tr>
              <td>Earnings</td>
              <td><?php echo $this->largeNumber::format($posts[0]->total_pending_payout_value); ?></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    {% include 'forums/_breadcrumb.volt' %}
    <div class="row stackable">
      <div class="three wide column"></div>
      <div class="ten wide column">
        <div class="ui header">
          Reply to this thread
          <div class="sub header">
            &#x21b3;
            <a href="/forums/{{ posts[0].url }}">
              {{ posts[0].title }}
            </a>
            <div style="margin-left: 20px">
              &#x21b3; by
              <a href="/@{{ posts[0].author }}">
                @{{ posts[0].author }}
              </a>
            </div>
          </div>
        <div class='steemconnect reply'>
          <form class='ui reply form' action='http://steemjs.com/sign/comment' method='get' target='iframe'>
            <input type='hidden' name='parent_permlink' value='{{ posts[0].permlink}}'>
            <input type='hidden' name='parent_author' value='{{ posts[0].author}}'>
            <input type="hidden" name='json_metadata' value='{"app": "steemdb/0.1", "format": "markdown"}'>
            <div class='field'><textarea name='body'></textarea></div>
            <div class='ui primary submit labeled icon button'><i class='icon edit'></i> Add Reply</div>
          </form>
        </div>
      </div>
    </div>
    {% include 'forums/_breadcrumb.volt' %}
    <div class="row"></div>
    <div class="ui modal steemconnect">
      <div class="content">
        <div class="ui embed"></div>
      </div>
      <div class="actions">
        <div class="ui cancel button">Close</div>
      </div>
    </div>
  </div>
</div>

{% endblock %}

{% block scripts %}
<script>
$( document ).ready(function() {
  var validation  = {
        cusname:{
          identifier:'body',
          rules:[
            { type:'empty'}
          ]
        }
      },
      settings = {
        onFailure: function(){
          alert('fail');
          return false;
        },
        onSuccess: function(e){
          var form = $(this),
              data = form.serialize()
              embed = $(".ui.modal.steemconnect .ui.embed")
                .attr("data-url", "https://steemjs.com/sign/comment?" + data);
          $(".ui.modal.steemconnect")
            .modal({
              onShow: function() {
                $(".ui.modal.steemconnect .ui.embed").embed();
              },
            })
            .modal('show');
          // alert('test');
          return false;
        }
      };

  $("a.reply[data-permlink][data-author]").on('click', function() {
    var permlink = $(this).attr("data-permlink"),
        author = $(this).attr("data-author"),
        parent_permlink = $("<input type='hidden' name='parent_permlink'>").attr("value", permlink),
        parent_author = $("<input type='hidden' name='parent_author'>").attr("value", author),
        json_metadata = $("<input type='hidden' name='json_metadata' value='{\"app\": \"steemdb/0.1\", \"format\": \"markdown\"}'>"),
        body = $("<div class='field'><textarea name='body'></textarea></div>"),
        button = $("<div class='ui primary submit labeled icon button'><i class='icon edit'></i> Add Reply</div>"),
        form = $("<form class='ui reply form' action='http://steemjs.com/sign/comment' method='get' target='iframe'>").append(parent_author, parent_permlink, json_metadata, body, button),
        container = $("<div class='steemconnect reply' data-author='"+author+"' data-permlink='"+permlink+"'>").append(form),
        display = $(this).data("display");
    $("div.steemconnect[data-author="+author+"][data-permlink="+permlink+"]").remove();
    if(!display) {
      form.form(settings);
      $(this).parent().parent().after(container);
      $(this)
        .data("display", true)
        .html("Cancel");

    } else {
      $(this)
        .data("display", false)
        .html("Reply");
    }

    // <div class='steemconnect reply'>
    //   <form class='ui reply form' action='http://steemjs.com/sign/comment' method='get' target='iframe'>
    //     <input type='hidden' name='parent_permlink' value='{{ post.permlink}}'>
    //     <input type='hidden' name='parent_author' value='{{ post.author}}'>
    //     <div class='field'><textarea name='body'></textarea></div>
    //     <div class='ui primary submit labeled icon button'><i class='icon edit'></i> Add Reply</div>
    //   </form>
    // </div>

  });


  $('.ui.embed').embed();
  $('.ui.form').form(settings);

  $(".ui.segment.quoted.minimized").each(function() {
    if($(this).outerHeight() < 210) {
      console.log("removing");
      $(this).removeClass("minimized");
      $(this).find(".read-more").remove();
    }
  });

  $(".read-more button").on('click', function() {
    var button = $(this),
        controls = button.parent(),
        container = controls.parent();
    container.removeClass('minimized');
    console.log(container);
    controls.remove();

    return false;
  });
});

</script>
{% endblock %}
