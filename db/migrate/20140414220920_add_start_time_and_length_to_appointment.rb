class AddStartTimeAndLengthToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :start_time, :datetime
    add_index :appointments, :start_time, unique: true
    add_column :appointments, :length, :integer
  end
end
