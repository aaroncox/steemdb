<?php
namespace BexNetwork\Controllers;

use BexNetwork\Models\Block;

class BlockController extends ControllerBase
{

  public function viewAction()
  {
    $height = $this->dispatcher->getParam("height");
    $this->view->current = Block::findFirst(array(
      array(
        '_id' => (int) $height
      )
    ));
    if(!$this->view->current) {
      $this->flashSession->error('Block "'.$block.'" does not exist on BexNetwork currently.');
      $this->response->redirect();
      return;
    }
  }

}
