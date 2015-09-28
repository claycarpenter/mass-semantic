
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
  $.fn.toggleButtonDisable = function (action) {
    var isDisabling = false;

    if (action === 'disable') {
      isDisabling = true;
    }

    this.each(function () {
      if (isDisabling) {
        $(this).addClass('disabled');
        $(this).attr('disabled', 'disabled');
      } else {
        $(this).removeClass('disabled');
        $(this).removeAttr('disabled');
      }
    });
  };
})(jQuery);

(function ($) {
  $.fn.ajaxJsonForm = function (options) {
    var settings = $.extend({
      success: function (form, data) { /* Do nothing */ }
    }, options);

    this.each(function () {
      $(this).on('submit', function (evt) {
        var form, url, formData;

        form = $(this);
        url = form.attr('action');
        formData = JSON.stringify(form.serializeJSON());

        form.find('input[type="submit"]').toggleButtonDisable('disable');

        function formSuccess (data) {
          form.find('input[type="submit"]').toggleButtonDisable('enable');

          settings.success(form, data);
        }

        $.ajax({
          url: url,
          method: 'POST',
          data: formData,
          contentType: "application/json; charset=utf-8",
          success: formSuccess,
          dataType: 'json'
        });

        return false;
      });
    });
  };
})(jQuery);

$(function () {
  $('.btn.toggle-form').toggleButton();

  $('form').ajaxJsonForm({
    success: function (form, data) {
      location.reload();
    }
  });
});
