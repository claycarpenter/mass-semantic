
  function success (data) {
    console.log("Response received!");
  }

  function jsonFormPost (form) {
    console.log('Sending to:', form.attr('action'));
    console.log('Sending payload:', JSON.stringify(form.serializeJSON()));

    $.ajax({
      url: form.attr('action'),
      method: 'POST',
      data: JSON.stringify(form.serializeJSON()),
      contentType: "application/json; charset=utf-8",
      success: success,
      dataType: 'json'
    });
  }

$(function () {

  $(".btn.toggle-form").on('click', function (evt) {
    var toggleFormTarget,
        toggleForm;

    toggleFormTarget = $(this).next('.toggle-form-target');
    toggleForm = toggleFormTarget.find('form');

    toggleFormTarget.slideToggle();

    toggleForm.on('submit', function (evt) {
      console.log($(this));

      $(this).find('input[type=submit]').attr('disabled', 'disabled');

      jsonFormPost($(this));

      return false;
    });
  });
});
