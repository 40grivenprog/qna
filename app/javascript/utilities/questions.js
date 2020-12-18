$(document).on('turbolinks:load', function(){
   $('.questions').on('click', '.edit-question-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var questionId = $(this).data('questionId');
       $('form#edit-question-' + questionId).removeClass('hidden');
   })
    $('.questions').on('click', '.cancel-edit-question-link', function(e) {
       e.preventDefault();
       var questionId = $(this).data('questionId');
       $('form#edit-question-' + questionId).addClass('hidden');
       $('#edit-' + questionId + '-question').show();
   })
  $('.votes_section').on('ajax:success', function(e) {
    let result = e.detail[0].vote_result
    $('.question_votes_result').children('h3').text('Rating result: ' + result)
   })
});
