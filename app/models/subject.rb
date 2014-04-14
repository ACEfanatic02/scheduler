class Subject < ActiveRecord::Base
  validates :course_number, presence: true
  validates :course_name, presence: true
end
