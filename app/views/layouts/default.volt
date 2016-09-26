<!DOCTYPE html>
<html>
  <head>
    <meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no,minimal-ui' />
    <title>steemdb</title>
    <style>
      .ui.top.fixed.massive.menu .item {
        padding: 1.25em;
      }
      body.pushable>.pusher {
        background: #efefef;
      }
      .ui.vertical.stripe {
        padding: 3em 0em;
      }
      .ui.vertical.stripe h3 {
        font-size: 2em;
      }
      .ui.vertical.stripe .button + h3,
      .ui.vertical.stripe p + h3 {
        margin-top: 3em;
      }
      .ui.vertical.stripe .floated.image {
        clear: both;
      }
      .ui.vertical.stripe p {
        font-size: 1.33em;
      }
      .ui.vertical.stripe .horizontal.divider {
        margin: 3em 0em;
      }
      .quote.stripe.segment {
        padding: 0em;
      }
      .quote.stripe.segment .grid .column {
        padding-top: 5em;
        padding-bottom: 5em;
      }
      .footer.segment {
        padding: 5em 0em;
      }
      .footer.segment a {
        color: #fff;
        text-decoration: underline;
      }
      .comment img,
      .markdown img {
        max-width: 100%;
        height:auto;
        display: block;
      }
      .ui.comments {
        max-width: auto;
      }
      .ui.comments .comment .comments {
        padding-left: 3em;
      }
      .definition.table td.wide {
        overflow-x: auto;
      }
      @media only screen and (min-width: 769px) {
        .mobile.visible {
          display: none
        }
      }
      @media only screen and (max-width: 768px) {
        .ui.tabular.menu {
          overflow-y: scroll;
        }
        .mobile.hidden {
          display: none !important;
        }
      }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.2/semantic.min.css">
    <link rel="stylesheet" href="/bower/plottable/plottable.css">
  </head>
  <body>

    <div class="ui fixed inverted main menu">
      <div class="ui container">
        <a class="launch icon item">
          <i class="content icon"></i>
        </a>

          <div class="item">
            Menu
          </div>

        <div class="right menu">
          <!--
          <div class="item">
            <div class="ui hidden right aligned search input" id="search">
              <div class="ui transparent icon input">
                <input class="prompt" type="text" placeholder="Search...">
                <i class="inverted search link icon" data-content="Search UI"></i>
              </div>
              <div class="results"></div>
            </div>
          </div>
          -->
        </div>
      </div>
    </div>
    <!-- Following Menu -->
    <div class="ui large blue inverted top fixed massive menu">
      <div class="ui container">
        <a href="/" class="{{ (router.getControllerName() == 'comment') ? 'active' : '' }} item">posts</a>
        <a href="/accounts" class="{{ (router.getControllerName() == 'account' or router.getControllerName() == 'accounts') ? 'active' : '' }} item">accounts</a>
        <a href="/witnesses" class="{{ (router.getControllerName() == 'witness') ? 'active' : '' }} item">witnesses</a>
        <a href="/labs" class="{{ (router.getControllerName() == 'labs') ? 'active' : '' }} item">labs</a>
        <div class="right menu">
          <div class="item">
            <a href="https://steemit.com/?r=jesta">
              <small>Create Account</small>
            </a>
          </div>
          <div class="ui category search item">
            <div class="ui icon input">
              <input class="prompt" type="text" placeholder="Search accounts...">
              <i class="search icon"></i>
            </div>
            <div class="results"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Sidebar Menu -->
    <div class="ui vertical inverted sidebar menu">
      <a href="/" class="{{ (router.getControllerName() == 'comment') ? 'active' : '' }} item">posts</a>
      <a href="/accounts" class="{{ (router.getControllerName() == 'account') ? 'active' : '' }} item">accounts</a>
      <a href="/witnesses" class="{{ (router.getControllerName() == 'witness') ? 'active' : '' }} item">witnesses</a>
    </div>

    <!-- Page Contents -->
    <div class="pusher" style="padding-top: 5em">
      {% block header %}{% endblock %}

      {% if this.flashSession.has() %}
      <div class="ui container">
        <div class="ui error message">
          <?php $this->flashSession->output() ?>
        </div>
      </div>
      {% endif %}

      {% block content %}{% endblock %}

      <div class="ui container">
        <div class="ui basic segment">
          <div class="ui tiny center aligned header">
            * All Steem Power & VEST calculations are done using the current conversion rate, not a historical rate. This may cause some calculations to be incorrect.
          </div>
        </div>
      </div>
      <div class="ui inverted vertical footer segment">
        <div class="ui container">
          <div class="ui stackable inverted divided equal height stackable grid">
<!--             <div class="three wide column">
              <h4 class="ui inverted header"></h4>
              <div class="ui inverted link list">

              </div>
            </div>
            <div class="three wide column">
              <h4 class="ui inverted header"></h4>
              <div class="ui inverted link list">

              </div>
            </div>
            <div class="three wide column">
              <h4 class="ui inverted header"></h4>
              <div class="ui inverted link list">

              </div>
            </div> -->
            <div class="sixteen wide center aligned column">
              <h4 class="ui inverted header">
                <a href="https://steemdb.com">steemdb</a>
                created by
                <a href="https://steemit.com/@jesta">@jesta</a>
              </h4>
              <p>If you'd like to support this project, <a href="https://steemit.com/~witnesses">vote <strong>jesta</strong> as witness.</a></p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script type="text/javascript" src="https://code.jquery.com/jquery-3.1.0.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.2/semantic.min.js"></script>
    <script type="text/javascript" src="/bower/d3/d3.min.js"></script>
    <script type="text/javascript" src="/bower/plottable/plottable.min.js"></script>
    <script type="text/javascript" src="/js/tablesort.js"></script>

    {% block scripts %}{% endblock %}
    <script>
    $(document)
      .ready(function() {

        $('.ui.category.search')
          .search({
            apiSettings: {
              url: '/search?q={query}'
            },
            debug: true,
            type: 'category'
          })
        ;

        $('.ui.sortable.table').tablesort();

        // create sidebar and attach to menu open
        // $('.ui.sidebar')
        //   .sidebar('attach events', '.toc.item')
        // ;

        $('.ui.dropdown')
          .dropdown({

          })
        ;

        $('[data-popup]')
          .popup({
            hoverable: true
          })
        ;

        $('.ui.dropdown.tags')
          .dropdown({
            onChange: function(value, text, $choice) {
              var selectedSort = $("#selectedSort").val(),
                  selectedDate = $("#selectedDate").val();
              window.location.href = value + '/' + selectedSort + '/' + selectedDate;
            },
            apiSettings: {
              url: '/api/tags/{query}'
            }
          });

      })
    ;
    </script>
    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

      ga('create', 'UA-81121004-2', 'auto');
      ga('send', 'pageview');

    </script>
  </body>
</html>
