<?php
namespace SteemDB\Controllers;

use MongoDB\BSON\UTCDateTime;

use SteemDB\Models\BenefactorReward;
use SteemDB\Models\Status;

class AppsController extends ControllerBase
{

  public function indexAction()
  {

    $platforms = [
      'steemit' => ['steemit'],
      'esteem' => ['esteemapp', 'esteem'],
      'chainbb' => ['chainbb'],
      'dsound' => ['dsound'],
      'dtube' => ['dtube'],
      'busy' => ['busy'],
      'steepshot' => ['steepshot'],
      'utopian' => ['utopian-io'],
      'zappl' => ['zappl'],
    ];
    $this->view->platforms = array_keys($platforms);
    $beneficiaries = call_user_func_array('array_merge', array_values($platforms));
    $benefactors = BenefactorReward::getDatedByPlatform();
    $apps = [];
    $dates = [];
    foreach($benefactors as $reward) {
      $dates[] = $reward->_id['year'] . "-" . $reward->_id['month'] . "-" . $reward->_id['day'];
      foreach($reward['benefactors'] as $benefactor) {
        if(in_array($benefactor->benefactor, $beneficiaries)) {
          if(!isset($apps[$benefactor->benefactor])) {
            $apps[$benefactor->benefactor] = [
              'name' => $benefactor->benefactor,
              'data' => []
            ];
          }
          $apps[$benefactor->benefactor]['data'][] = $benefactor->reward;
        }
      }
    }
    $this->view->appdates = $dates;
    $this->view->apps = array_values($apps);


    $results = Status::findFirst([['_id' => 'clients-snapshot']]);
    // var_dump($results->data->toArray()); exit;
    $this->view->dates = $results->data;
    $rewards = [];
    $dominance = [];
    $dominancedates = [];
    $clients = [];
    foreach($results->data as $date) {
      foreach($date->clients as $client) {
        $clients[] = $client->client;
      }
    }
    $clients = array_values(array_unique($clients));
    foreach($results->data as $date) {
      $counts = array_combine(array_column($date->clients, 'client'), array_column($date->clients, 'count'));
      array_push($dominancedates, $date->_id->year . "-" . $date->_id->month . "-" . $date->_id->day);
      foreach($clients as $client) {
        if(in_array($client, $beneficiaries)) {
          if(!isset($dominance[$client])) $dominance[$client] = ['name' => ($client) ? $client : 'unknown', 'data' => []];
          if(isset($counts[$client])) {
            array_push($dominance[$client]['data'], $counts[$client]);
          } else {
            array_push($dominance[$client]['data'][], 0);
          }
        }
      }
      foreach($date->clients as $client) {
        if(in_array($client->client, $beneficiaries)) {
          if(!isset($rewards[$client->client])) $rewards[$client->client] = [
            'name' => $client->client,
            'y' => 0
          ];
          $rewards[$client->client]['y'] += $client->reward;
        }
      }
    }
    foreach($dominance as $client => $data) {
      $dominance[$client]['data'] = array_reverse($data['data']);
    }
    // arsort($posts);
    // arsort($rewards);
    $this->view->rewards = array_values($rewards);

    // $this->view->dominancedates = array_reverse(array('2017-06-01','2017-06-02','2017-06-03','2017-06-04','2017-06-05','2017-06-06','2017-06-07','2017-06-08','2017-06-09','2017-06-10'));
    // $this->view->dominance = array_reverse(array(
    //   ['name' => 'test1', 'data' => [1,2,3,4,5,6,7,8,9,10]],
    //   ['name' => 'test2', 'data' => [1,2,3,4,5,6,7,8,9,10]],
    //   ['name' => 'test3', 'data' => [1,2,3,4,5,6,7,8,9,10]],
    //   ['name' => 'test4', 'data' => [1,2,3,4,5,6,7,8,9,10]],
    // ));
    $this->view->dominance = array_values($dominance);
    // var_dump($dominance); exit;
    $this->view->dominancedates = array_values(array_reverse($dominancedates));
    // var_dump($this->view->dominance, $this->view->dominancedates); exit;
  }

}
