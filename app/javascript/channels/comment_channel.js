import consumer from "./consumer"
$(document).on('turbolinks:load', function() {
  consumer.subscriptions.create({ channel: "CommentChannel", question_id: gon.question_id }, {
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
})
