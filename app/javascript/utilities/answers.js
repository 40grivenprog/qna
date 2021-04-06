$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answerId');
       $('form#edit-answer-' + answerId).removeClass('hidden');
   })
    $('.answers').on('click', '.cancel-edit-question-link', function(e) {
       e.preventDefault();
       var answerId = $(this).data('answerId');
       $('form#edit-answer-' + answerId).addClass('hidden');
       $('#edit-' + answerId + '-answer').show();
   })
    $('.answer_votes_section').on('ajax:success', function(e) {
      let result = e.detail[0].vote_result;
      let id = e.detail[0].record_id;
      $('.answer_' + id +'_votes_result').children('h3').text('Rating result: ' + result)
     })
});
