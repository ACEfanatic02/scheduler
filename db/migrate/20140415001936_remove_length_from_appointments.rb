class RemoveLengthFromAppointments < ActiveRecord::Migration
  def change
    remove_column :appointments, :length, :integer
    add_column :appointments, :end_time, :datetime
  end
end
