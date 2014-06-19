var teamNames = ['A', 'B', 'C'];
$(function() {
  $.getJSON('/answer', showAnswers);

  $('#answer-reset').click(function() {
    $.get('/reset', null, function() {
      location.reload();
    });
  });

  $('#answer-show').click(function() {
    $.get('/answer/show', null, function() {
      location.reload();
    });
  });

  $('#answer-hide').click(function() {
    $.get('/answer/hide', null, function() {
      location.reload();
    });
  });

  $('#answer-mark').click(function() {
    var button = $(this);
    button.attr("disabled", true);


    var answerData = {'A': [], 'B': [], 'C': []};
    console.log(answerData);
    teamNames.forEach(function(teamId) {
      for (var i = 1; i <= 4; i++) {
        isChecked = ($('#'+ teamId +'-'+ i).prop('checked')) ? 1 : 0;
        answerData[teamId].push(isChecked);
      }
    });
    console.log(answerData);

    $.ajax({
      type:"post",
      url:"/answer/mark",
      data:JSON.stringify(answerData),
      contentType: 'application/json',
      dataType: "json",
      success: function(json_data) {
        location.reload();
      },
      error: function() {
        alert("Server Error. Pleasy try again later.");
      },
      complete: function() {
          button.attr("disabled", false);
      }
    });
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
