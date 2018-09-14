<?php
namespace BexNetwork\Controllers;

class IndexController extends ControllerBase
{
  public function indexAction()
  {
    return $this->response->redirect('/');
  }
  public function liveAction()
  {
    
  }
  public function show404Action() {

  }
}
