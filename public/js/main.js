var teamNames = ['A', 'B', 'C'];
$(function() {
  $.getJSON('http://localhost:3000/answer', showAnswers);
});
var showAnswers = function(data) {
  teamNames.forEach(function(teamId) {
    showAnswer(teamId, data[teamId]);
  });
}

function showAnswer(teamId, data) {
  data.forEach(function(answer) {
    var answerDiv   = $("#team-"+ teamId +" div")[answer.answer_number-1];
    var answerImage = $("#team-"+ teamId +" img")[answer.answer_number-1];

    var imageUrl = '/img/question_mark-blue.png';
    if (answer.marked != 0) {
      imageUrl = answer.image_url;
    }
    if (answer.marked == 1) {
      $(answerDiv).addClass('answer-opened');
    }
    if (answer.marked == 2) {
      $(answerDiv).removeClass('answer-opened');
      $(answerDiv).addClass('answer-ok');
    }
    $(answerImage).attr('src', imageUrl);
  });
}
