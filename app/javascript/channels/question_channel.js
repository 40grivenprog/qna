import consumer from "./consumer"

consumer.subscriptions.create("QuestionChannel", {
received(data) {
  if (gon.currentUser != null){
  data.is_question_owner = gon.currentUser.id === data.question.user_id;
  }else{
  data.is_question_owner = false
  }
  if (data.is_question_owner) { return }
  $('.questions').append(data.partial);
  }
});
