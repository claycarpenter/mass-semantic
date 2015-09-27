
// Simple toggle button widget.
(function ($) {
  $.fn.toggleButton = function () {
    this.each(function () {
      $(this).on('click', function () {
        var target = $($(this).data('toggle-target'));
        target.slideToggle();
      });
    });
  };
})(jQuery);

(function ($) {
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

  $.fn.ajaxJsonForm = function () {
    this.each(function () {
      $(this).on('submit', function (evt) {
        jsonFormPost($(this));

        return false;
      });
    });
  };
})(jQuery);

$(function () {
  $('.btn.toggle-form').toggleButton();

  $('form').ajaxJsonForm();
});
