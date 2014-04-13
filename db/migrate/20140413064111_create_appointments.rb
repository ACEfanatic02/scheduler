class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.belongs_to :tutor
      t.belongs_to :client

      t.timestamps
    end
  end
end
