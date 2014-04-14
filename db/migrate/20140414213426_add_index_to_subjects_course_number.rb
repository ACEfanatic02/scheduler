class AddIndexToSubjectsCourseNumber < ActiveRecord::Migration
  def change
    add_index :subjects, :course_number, unique: true
  end
end
