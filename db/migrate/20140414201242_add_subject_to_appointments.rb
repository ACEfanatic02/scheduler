class AddSubjectToAppointments < ActiveRecord::Migration
  def change
    add_reference :appointments, :subject
  end
end
