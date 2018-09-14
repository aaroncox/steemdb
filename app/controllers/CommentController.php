<?php
namespace BexNetwork\Controllers;

use MongoDB\BSON\UTCDateTime;

use BexNetwork\Models\Account;
use BexNetwork\Models\Comment;
use BexNetwork\Models\Reblog;
use BexNetwork\Models\Vote;

class CommentController extends ControllerBase
{

  private function getComment()
  {
    // Get route information
    $tag = $this->dispatcher->getParam("tag", ["string", "lower"]);
    $author = $this->dispatcher->getParam("author", ["string", "lower"]);
    $permlink = $this->dispatcher->getParam("permlink", ["string", "lower"]);
    // Load the Post
    $query = array(
      '_id' => $author . '/' . $permlink
    );
    $comment = $this->view->comment = Comment::findFirst(array(
      $query
    ));
    // Load author data
    $query = array(
      'name' => $comment->author
    );
    $this->view->author = Account::findFirst(array($query));
    // And some additional posts for "Read more"
    $this->view->posts = Comment::find(array(
      array(
        'author' => $comment->author,
        'depth' => 0,
      ),
      'sort' => array('created' => -1),
      'limit' => 5
    ));
    // Set our default view
    $this->view->pick("comment/view");
    return $comment;
  }

  public function viewAction()
  {
    $comment = $this->getComment();
  }

  public function dataAction()
  {
    $comment = $this->getComment();
  }

  public function tagsAction()
  {
    $comment = $this->getComment();
  }

  public function jsonAction()
  {
    $comment = $this->getComment();
    header('Content-type:application/json');
    $this->view->disable();
    ini_set('precision', 20);
    echo json_encode($comment, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
  }

  public function votesAction()
  {
    $comment = $this->getComment();
    // Sort the votes by rshares
    $query = [
      'author' => $comment->author,
      'permlink' => $comment->permlink,
    ];
    $this->view->votes = $votes = Vote::find([
      $query,
      "sort" => ['_ts' => 1]
    ]);
  }

  public function reblogsAction()
  {
    $comment = $this->getComment();
    $query = array(
      'permlink' => $comment->permlink,
      'author' => $comment->author,
    );
    $this->view->reblogs = Reblog::find(array(
      $query,
      "sort" => ['_ts' => 1]
    ));
  }

  public function repliesAction()
  {
    $comment = $this->getComment();
    $query = array(
      'parent_author' => $comment->author,
      'parent_permlink' => $comment->permlink
    );
    $this->view->replies = Comment::find(array(
      $query,
      "sort" => ['created' => -1]
    ));
  }

}
