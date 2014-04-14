class CreateSubjectsTutorsJoinTable < ActiveRecord::Migration
  def change
    create_table :subjects_tutors, id: false do |t|
      t.integer :subject_id
      t.integer :tutor_id
    end
  end
end
