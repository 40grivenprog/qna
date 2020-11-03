import consumer from "./consumer"

consumer.subscriptions.create("AnswerChannel", {
  received(data) {
    let question_id = data.answer.question_id;
    let answer_id = data.answer.id
    let author_id = data.answer.user_id;
    if (gon.currentUser != null){
      data.is_question_owner = gon.currentUser.id === data.question.user_id;
      data.is_answer_owner =  gon.currentUser.id === data.answer.user_id;
    }else{
      data.is_question_owner = false
    }
    if (data.is_answer_owner) { return };
    $('.question_' + question_id + '_answers').append(data['partial']);
    if (data.is_question_owner){
      const template = require('./templates/answer.hbs');
      $('#answer-id-' + answer_id).append(template(data.answer))
    }
  }
});
