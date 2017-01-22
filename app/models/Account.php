<?php
namespace SteemDB\Models;

class Account extends Document
{

  public function profileImage() {
    if(property_exists($this, 'json_metadata') && !is_array($this->json_metadata)) {
        $this->json_metadata = json_decode($this->json_metadata, true);
    }
    if(property_exists($this, 'json_metadata') && isset($this->json_metadata['profile']) && isset($this->json_metadata['profile']['profile_image'])) {
        return $this->json_metadata['profile']['profile_image'];
    }
    return null;
  }

}
