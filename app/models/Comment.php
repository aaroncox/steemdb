<?php
namespace SteemDB\Models;

class Comment extends Document
{

  public function metadata($key = null) {
    // Return an empty array if we have nothing
    if(!$this->json_metadata) return [];
    // If we have an object with data, use that
    if(!is_string($this->json_metadata)) {
      if($key && isset($this->json_metadata->$key)) {
        return $this->json_metadata->$key;
      }
      return $this->json_metadata;
    }
    // If we have a string of json, decode and return
    $metadata = json_decode($this->json_metadata, true);
    if($key && isset($metadata[$key])) {
      $metadata = $metadata[$key];
    }
    return $metadata;
  }

  public function getChildren() {
    $query = array(
      'parent_permlink' => $this->permlink
    );
    return Comment::find(array(
      $query
    ));
  }

}

