$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answerId');
       $('form#edit-answer-' + answerId).removeClass('hidden');
   })

   $('.votes_section').on('ajax:success', function(e) {
    let result = e.detail[0].vote_result
    $('.question_votes_result').children().text(result)
   })
});
