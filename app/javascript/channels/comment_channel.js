import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  received(data) {
    if (gon.currentUser != null){
      data.is_comment_owner = gon.currentUser.id === data.comment.user_id;
    }else{
      data.is_comment_owner = false
    }
    if(data.is_comment_owner){ return }
    if(data.comment.commentable_type == "Question"){
      $('.question_comments').append(data.partial);
    }else{
      let answer_id = data.comment.commentable_id
      $(".answer_" + answer_id + "_comments").append(data.partial);
    }
  }
});
