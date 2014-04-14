class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :course_number
      t.string :course_name

      t.timestamps
    end
  end
end
