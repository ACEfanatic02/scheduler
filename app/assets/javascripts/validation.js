/**
 * Helper functions to validate forms.
 */
var Validate = {

  markError: function (field) {
    field.addClass('form-field-error');
  },

  fieldNotEmpty: function (field) {
    if (field.val().trim()) {
      return true;
    }
    else {
      Validate.markError(field);
      return false;
    }
  },

  fieldsMatch: function (fieldA, fieldB) {
    if  (fieldA.val() === fieldB.val()) {
      return true;
    }
    else {
      Validate.markError(fieldA);
      Validate.markError(fieldB);
      return false;
    }
  },

  email: function (field) {
    if (field.val().match(/.+@.+\..+/)) {
      return true;
    }
    else {
      Validate.markError(field);
      return false;
    }
  }
};

var validateRegistrationForm = function() {
  var errors = [];

  var username_elem = $('input[name=username]');
  var email_elem = $('input[name=email]');
  var password_elem = $('input[name=password]');
  var password_confirmation_elem = $('input[name=password_confirmation]');

  var valid = true;

  /* We want to mark *all* errors, so don't short-circuit the validation call. */
  valid = Validate.fieldNotEmpty(username_elem) && valid;
  valid = Validate.fieldNotEmpty(email_elem) && valid;
  valid = Validate.fieldNotEmpty(password_elem) && valid;
  valid = Validate.fieldNotEmpty(password_confirmation_elem) && valid;

  if (username_elem.val().trim().length > 50) {
    username_elem.addClass('form-field-error');
    errors.push("Username too long.");
    valid = false;
  }

  if (!Validate.email(email_elem)) {
    errors.push("Invalid email address.");
    valid = false;
  }

  if (password_elem.val().length < 8) {
    password_elem.addClass('form-field-error');
    errors.push("Password too short.");
    valid = false;
  }

  if (!Validate.fieldsMatch(password_elem, password_confirmation_elem)) {
    errors.push("Password and confirmation do not match.");
    valid = false;
  }

  var error_list = $('.form-error-list');
  error_list.html("");
  if (errors.length) error_list.removeClass('hidden');
  for (var i = 0; i < errors.length; i++) {
    var error_elem = $("<p>");
    error_elem.addClass('form-error');
    error_elem.text(errors[i]);
    error_list.append(error_elem);
  };

  return valid;
}

var validateLoginForm = function() {
  var email_elem = $('input[name=email]');
  var password_elem = $('input[name=password]');

  valid = true;

  valid = Validate.fieldNotEmpty(email_elem) && valid;
  valid = Validate.fieldNotEmpty(password_elem) && valid;

  return valid;
}