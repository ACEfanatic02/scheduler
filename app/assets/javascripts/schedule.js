$(function() {

  $('.schedule-table-schedule-block').click(function(e) {
    var time = $(this).data('time');
    var tutor = $(this).closest('tr').data('tutor-id');
    var link = $(this).data('appt-link');

    window.location = link;
  });

});
