<?php
namespace SteemDB\Controllers;

class TxController extends ControllerBase
{

  public function viewAction()
  {
    $this->view->id = $id = $this->dispatcher->getParam("id");
    $this->view->current = $this->steemd->getTx($id);
    // var_dump($this->view->current); exit;
  }

}
