<div class="ui fixed inverted blue main menu">
  <div class="ui container">
    <a class="launch icon item">
      <i class="content icon"></i>
    </a>

    <div class="right menu">
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
<!-- Following Menu -->
<div class="ui blue inverted top fixed mobile hidden menu">
  <div class="ui container">
    <span class="header item">BexNetwork</span>
    <a href="/" class="{{ (router.getControllerName() == 'comment') ? 'active' : '' }} item">posts</a>
    <a href="/accounts" class="{{ (router.getControllerName() == 'account' or router.getControllerName() == 'accounts') ? 'active' : '' }} item">accounts</a>
    <a href="/witnesses" class="{{ (router.getControllerName() == 'witness') ? 'active' : '' }} item">witnesses</a>
    <a href="https://blog.bex.network" class="item">updates</a>
    <a href="/labs" class="{{ (router.getControllerName() == 'labs') ? 'active' : '' }} item">labs</a>
    <div class="right menu">
      <div class="item">
        <a href="https://dsite.io/?r=jared">
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
      <div class="ui dropdown item">
        dPay <i class="dropdown icon"></i>
        <div class="menu">
          <a class="item" href="https://bex.network{{ router.getRewriteUri() }}">dPay</a>
          <a class="item" href="https://golosdb.com{{ router.getRewriteUri() }}">Arise</a>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Sidebar Menu -->
<div class="ui vertical inverted sidebar menu">
  <a href="/" class="{{ (router.getControllerName() == 'comment') ? 'active' : '' }} item">posts</a>
  <a href="/accounts" class="{{ (router.getControllerName() == 'account' or router.getControllerName() == 'accounts') ? 'active' : '' }} item">accounts</a>
  <a href="/witnesses" class="{{ (router.getControllerName() == 'witness') ? 'active' : '' }} item">witnesses</a>
  <a href="https://blog.bex.network" class="item">updates</a>
  <a href="/labs" class="{{ (router.getControllerName() == 'labs') ? 'active' : '' }} item">labs</a>
</div>
