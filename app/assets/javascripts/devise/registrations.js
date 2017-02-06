$(document).on('turbolinks:load', function () {
  $('#choose_photo').click(function() {
    $('#image_field').click();
  });

  $('#image_field').change(function() {
    $(this).closest('span.input-group-btn').parent().find('.form-control').
      html($(this).val().split(/[\\\\|/]/).pop());
  });

  $('#photo_name').html($(image_field).val().split(/[\\\\|/]/).pop());
});
