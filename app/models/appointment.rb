class Appointment < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :client
  belongs_to :subject

  validates :tutor, presence: true
  validates :client, presence: true
  validates :subject, presence: true
  validates_presence_of :notes, if: ->(appt) {
    appt.subject && appt.subject.course_number == "Other"
  }

  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :tutor_teaches_subject
  validate :positive_time_range

  validates_uniqueness_of :tutor, if: ->(appt) { 
    Appointment.where("((start_time < ?) and (end_time > ?))", end_time, start_time).exists? 
  }

  def length
    ((end_time - start_time) / 60).floor
  end

  def length=(len)
    self.end_time = start_time + (60 * len)
  end

  def positive_time_range
    unless start_time && end_time && (end_time - start_time > 0)
      errors.add(:length, "appointment length must be positive")
    end
  end

  def tutor_teaches_subject
    unless subject && tutor && tutor.subjects.exists?(subject.id)
      errors.add(:subject, "tutor does not teach this subject") 
    end
  end
end
