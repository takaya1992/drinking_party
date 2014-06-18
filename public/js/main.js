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
    var answerImage = $("#team-"+ teamId +" img")[answer.answer_number-1];
    $(answerImage).attr('src', answer.image_url);
  });
}
