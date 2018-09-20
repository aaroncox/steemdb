<?php
namespace SteemDB\Controllers;

class BlockController extends ControllerBase
{

  public function viewAction()
  {
    $this->view->height = $height = $this->dispatcher->getParam("height");
    $this->view->current = $this->steemd->getBlock($height);
  }

}
