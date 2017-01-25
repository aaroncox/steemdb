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
          {{ posts[0].title }}
          <div class="sub header">
            &#x21b3; posted by
            <a href="/@{{ posts[0].author }}">
              {{ posts[0].author }}
            </a>
            &mdash;
            <?php echo $this->timeAgo::mongo($posts[0]->created); ?>
          </div>
          <div class="sub header" style="padding-left: 20px">
            <small>
              &#x21b3; in
              {% for tag in posts[0].metadata('tags') %}
              <a href="/forums/tag/{{ tag }}">
                #{{ tag }}
              </a>
              {% endfor %}
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
    {% for post in posts %}
    <a class="anchor" name="{{ post.author }}/{{ post.permlink}}"></a>
    <div class="row">
      <div class="three wide center aligned column">
        <div class="mobile hidden">
          <img src="https://img.steemconnect.com/@{{ post.author }}?size=80" class="ui tiny centered spaced circular bordered image">
          <div class="ui centered header">
            <a href="/@{{ post.author }}">
              @{{ post.author }}
            </a>
            {% if authors[post.author] %}
            <div class="sub header">
              {{ authors[post.author].post_count }} posts
            </div>
            {% endif %}
          </div>
        </div>
        <div class="mobile visible">
          <img src="https://img.steemconnect.com/@{{ post.author }}?size=60" class="ui right floated spaced circular bordered image">
        </div>
      </div>
      <div class="thirteen wide column">
        <div class="ui comments">
          <div class="comment">
            <div class="content">
              <div class="mobile visible">
                <div class="ui small dividing header">
                  <div class="content">
                    <a href="/@{{ post.author }}">
                      @{{ post.author }}
                    </a>
                    {% if authors[post.author] %}
                    <div class="sub header">
                      {{ authors[post.author].post_count }} posts
                    </div>
                    {% endif %}
                  </div>
                </div>
              </div>
              <div class="text">
                <div class="markdown">
                  {% if post.depth > 0 and post.parent_permlink != posts[0].permlink %}
                  <?php
                    $key = array_search($post->parent_permlink, array_column($posts, 'permlink'));
                  ?>
                  <div class='ui secondary segment quoted minimized'>
                    <div class="comment">
                      {#<a class="avatar">
                        <img src="/images/avatar/small/steve.jpg">
                      </a>#}
                      <div class="content">
                        <a class="author" href="/@{{ posts[key].author }}">
                          @{{ posts[key].author }}
                        </a>
                        <div class="metadata">
                          <div class="date">
                            quote from
                            <?php echo $this->timeAgo::mongo($posts[$key]->created); ?>
                            &mdash;
                            <a href="#{{ posts[key].author }}/{{ posts[key].permlink }}">
                              jump
                            </a>
                          </div>
                        </div>
                        <div class="text">
                          {{ markdown(posts[key].body) }}
                        </div>
                      </div>
                    </div>
                    <p class="read-more"><button class="ui primary button">Read More</button></p>
                  </div>
                  <br>
                  {% endif %}
                  {{ markdown(post.body) }}
                </div>
              </div>
              {% if loop.index == 1 %}
              <div class="ui horizontal tall stacked segments">
                <div class="ui center aligned segment">
                  <div class="ui sub header">created</div>
                  <?php echo $posts[0]->created->toDateTime()->format("M 'y") ?>
                </div>
                <div class="ui center aligned segment">
                  <a href="#<?php echo $posts[sizeof($posts) - 1]->author ?>/<?php echo $posts[sizeof($posts) - 1]->permlink ?>" class="content">
                    <div class="ui sub header">last reply</div>
                    <?php echo $posts[sizeof($posts) - 1]->created->toDateTime()->format("M 'y") ?>
                  </a>
                </div>
                <div class="ui center aligned segment">
                  <div class="ui sub header">replies</div>
                  {{ posts[0].children }}
                </div>
                <div class="ui center aligned segment">
                  <div class="ui sub header">users</div>
                  {{ unique_authors | length }}
                </div>
                <div class="ui center aligned segment">
                  <div class="ui sub header">votes</div>
                  {{ posts[0].net_votes }}
                  <svg height="16" style="vertical-align: middle" enable-background="new 0 0 33 33" version="1.1" viewBox="0 0 33 33" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Chevron_Up_Circle"><circle cx="16" cy="16" r="15" stroke="#121313" fill="none"></circle><path d="M16.699,11.293c-0.384-0.38-1.044-0.381-1.429,0l-6.999,6.899c-0.394,0.391-0.394,1.024,0,1.414 c0.395,0.391,1.034,0.391,1.429,0l6.285-6.195l6.285,6.196c0.394,0.391,1.034,0.391,1.429,0c0.394-0.391,0.394-1.024,0-1.414 L16.699,11.293z" fill="#121313"></path></g></svg>
                </div>
                <div class="ui center aligned segment">
                  <div class="ui sub header">resteems</div>
                  {{ resteems }}
                  <svg height="16" style="vertical-align: middle" version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve"><path d="M448,192l-128,96v-64H128v128h248c4.4,0,8,3.6,8,8v48c0,4.4-3.6,8-8,8H72c-4.4,0-8-3.6-8-8V168c0-4.4,3.6-8,8-8h248V96 L448,192z"></path></svg>
                </div>
                {#<div class="ui center aligned segment">
                  <div class="ui sub header">mode</div>
                  {{ posts[0].mode }}
                </div>#}
              </div>
              {% endif %}
              <div class="metadata">
                <div class="date">
                  Posted
                  <?php echo $this->timeAgo::mongo($post->created); ?>
                  {% if post.origin() %}
                    ( via
                    {% if post.origin() == 'steemit' %}
                    <a href="https://steemit.com/">steemit.com</a>
                    {% elseif post.origin() == 'busy' %}
                    <a href="https://busy.org/">busy.org</a>
                    {% elseif post.origin() == 'steemdb' %}
                    <a href="https://steemdb.com/">steemdb.com</a>
                    {% elseif post.origin() == 'esteem' %}
                    <a href="http://esteem.ws/">esteem</a>
                    {% else %}
                      Unknown - [{{ post.origin() }}]
                    {% endif %}
                    )
                  {% else %}
                  ( Unknown Source )
                  {% endif %}
                </div>
                <div class="actions">
                  <a class="reply" data-display="false" data-permlink="{{ post.permlink }}" data-author="{{ post.author }}">Reply to this post</a>
                  <a href="https://steemit.com{{ post.url }}" target="_blank">steem<strong>it</strong>.com</a>
                  <a href="https://steemdb.com/tag/@{{ post.author }}/{{ post.permlink }}" target="_blank">steem<strong>db</strong>.com</a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    {% endfor %}
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
    <div class="ui notice modal">
      <div class="header">
        Please note the following
      </div>
      <div class="content">
        <div class="ui padded basic segment" style="font: 16px">
          <p>
            Before you continue, please take a moment to understand how leaving a response on SteemDB works.
          </p>
          <p>
            The signing of these transactions uses tools provided by <a href="https://steemconnect.com/" target="_blank">SteemConnect.com</a>. SteemDB is embedding and using these tools to allow your actions to take place.
          </p>
          <p>
            <strong>For security reasons, we recommend you use your "posting" key to keep your account safe.</strong>
          </p>
          <p>
            Once you create a post or reply, it may take up to 1 minute to appear here on SteemDB.
          </p>
        </div>
        <div class="actions">
          <div class="ui primary button">I understand</div>
        </div>
      </div>
    </div>
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
          $('.notice.modal')
            .modal('show')
          ;
          $(".ui.modal.steemconnect")
            .modal({
              allowMultiple: false,
              onShow: function() {
                $(".ui.modal.steemconnect .ui.embed").embed();
              },
            })
            .modal('attach events', '.notice.modal .button')
          ;
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

  $('.ui.form').form(settings);
  $('.ui.embed[data-url]').embed();

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
