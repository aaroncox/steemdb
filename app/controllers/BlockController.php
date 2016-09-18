<?php
namespace SteemDB\Controllers;

use SteemDB\Models\Block;

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
    if(!$this->view->block) {
      $this->flashSession->error('Block "'.$block.'" does not exist on SteemDB currently.');
      $this->response->redirect();
      return;
    }
  }

}
