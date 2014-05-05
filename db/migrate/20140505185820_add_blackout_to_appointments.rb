class AddBlackoutToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :blackout, :boolean, null: false, default: false
  end
end
