<?php

use JsonRPC\Client;
use JsonRPC\HttpClient;

class dpayd
{

  protected $host;
  protected $client;

  public function __construct($host)
  {
    $this->host = $host;
    $httpClient = new HttpClient($host);
    $httpClient->withoutSslVerification();
    $this->client = new Client($host, false, $httpClient);
  }

  public function getState($path = "")
  {
    try {
      return $this->client->call(0, 'get_state', [$path]);
    } catch (Exception $e) {
      return array();
    }
  }

  public function getAccount($account)
  {
    try {
      $return = $this->client->call(0, 'get_accounts', [[$account]]);
      try {
        foreach($return as $index => $account) {
          $return[$index]['profile'] = json_decode($account['json_metadata'], true)['profile'];
        }
      } catch (Exception $e) {

      }
      return $return;
    } catch (Exception $e) {
      return array();
    }
  }
  public function getAccountHistory($username, $limit = 100, $skip = -1)
  {
    try {
      return $this->client->call(0, 'get_account_history', [$username, $skip, $limit]);
    } catch (Exception $e) {
      return array();
    }
  }

  public function getProps()
  {
    try {
      $return = $this->client->call(0, 'get_dynamic_global_properties', []);
      $return['dpay_per_mvests'] = floor($return['total_vesting_fund_dpay'] / $return['total_vesting_shares'] * 1000000 * 1000) / 1000;
      return $return;
    } catch (Exception $e) {
      return array();
    }
  }

  public function getApi($name)
  {
    return $this->client->call(1, 'get_api_by_name', [$name]);
  }

  public function getFollowing($username, $limit = 100, $skip = -1)
  {
    $api = $this->getApi('follow_api');
    return $this->client->call($api, 'get_following', [$username, $skip, $limit]);
  }
}
