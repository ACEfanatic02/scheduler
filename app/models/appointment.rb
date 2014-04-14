class Appointment < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :client
  belongs_to :subject

  validates :tutor, presence: true
  validates :client, presence: true
  validates :subject, presence: true

  validates :length, numericality: { greater_than_or_equal_to: 0 }
  validates :start_time, presence: true

  validate :tutor_teaches_subject

  def tutor_teaches_subject
    unless subject && tutor && tutor.subjects.exists?(subject.id)
      errors.add(:subject, "tutor does not teach this subject") 
    end
  end
end
