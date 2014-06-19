var teamNames = ['A', 'B', 'C'];
$(function() {
  $.getJSON('http://localhost:3000/answer', showAnswers);

  $('#reset-answer').click(function() {
    $.get('/reset', null, function() {
      location.reload();
    });
  });

  $('#mark-submit').click(function() {
    var answerData = {'A': [], 'B': [], 'C': []};
    console.log(answerData);
    teamNames.forEach(function(teamId) {
      for (var i = 1; i <= 4; i++) {
        isChecked = ($('#'+ teamId +'-'+ i).prop('checked')) ? 1 : 0;
        answerData[teamId].push(isChecked);
      }
    });
    console.log(answerData);
  });
});

var showAnswers = function(data) {
  teamNames.forEach(function(teamId) {
    showAnswer(teamId, data[teamId]);
  });
}

function showAnswer(teamId, data) {
  data.forEach(function(answer) {
    var answerImage = $("#team-"+ teamId +" img")[answer.answer_number-1];

      imageUrl = '/' + answer.image_url;
      $(answerImage).attr('src', imageUrl);
      $(answerImage).css('background-color', '#11F');
  });
}


function markAnswer(teamId) {
  
}
