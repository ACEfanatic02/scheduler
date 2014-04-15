class Subject < ActiveRecord::Base
  validates :course_number, presence: true, uniqueness: true
  validates :course_name, presence: true

  has_and_belongs_to_many :tutors
end
