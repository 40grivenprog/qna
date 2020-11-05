import consumer from "./consumer"
$(document).on('turbolinks:load', function() {
  consumer.subscriptions.create({ channel: "AnswerChannel", question_id: gon.question_id }, {
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

      $('.answer_votes_section').on('ajax:success', function(e) {
      let result = e.detail[0].vote_result;
      let id = e.detail[0].record_id;
      $('.answer_' + id + '_votes_result').children().text(result);
     })
    }
  }
  );
})
