module ScheduleHelper

  def hours_for_day(day, start_hour, end_hour)
    (start_hour..end_hour).map { |hour| day.change(hour: hour) }
  end
end
