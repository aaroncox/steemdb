<?php
namespace BexNetwork\Controllers;

class LiveController extends ControllerBase
{

  public function initialize()
  {
    header('Content-type:application/json');
    $this->view->disable();
    ini_set('precision', 20);
  }

  public function propsAction()
  {
    echo json_encode($this->dpayd->getProps(), JSON_PRETTY_PRINT);
  }

}
