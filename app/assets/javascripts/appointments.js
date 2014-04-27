$(function() {

  /* Toggle 'required' mark on notes -- only required for a subject of 'Other'. */
  $('#appt-subject').change(function (e) {
    if ($(this).val() == "Other") {
      $('#appt-form-notes-required').removeClass('hidden');
    }
    else {
      $('#appt-form-notes-required').addClass('hidden');
    }
  });

  function validateAppointmentForm() {
    var subject_elem = $('#appt-subject');
    var notes_elem = $('#appt-notes');
    var valid = true;

    // Clear previous errors.
    subject_elem.removeClass('form-field-error');
    notes_elem.removeClass('form-field-error');

    if (!subject_elem.val()) {
      subject_elem.addClass('form-field-error');
      valid = false;
    }

    if (subject_elem.val() == "Other") {
      if (!notes_elem.val()) {
        notes_elem.addClass('form-field-error');
        valid = false;
      }
    }
    return valid;
  }

  $('#appt-button-submit').click(function (e) {
    e.preventDefault();
    if (validateAppointmentForm()) {
      $('#new-appt-form').submit();
    }
  });

});