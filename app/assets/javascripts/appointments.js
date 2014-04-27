$(function() {

  $('#appt-subject').change(function (e) {
    if ($(this).val() == "Other") {
      $('#appt-form-notes-required').removeClass('hidden');
    }
    else {
      $('#appt-form-notes-required').addClass('hidden');
    }
  });

});