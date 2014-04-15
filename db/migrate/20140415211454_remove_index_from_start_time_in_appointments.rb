class RemoveIndexFromStartTimeInAppointments < ActiveRecord::Migration
  def change
    remove_index :appointments, :start_time
  end
end
