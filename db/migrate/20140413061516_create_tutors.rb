class CreateTutors < ActiveRecord::Migration
  def change
    create_table :tutors do |t|
      t.references :user

      t.timestamps
    end
  end
end
