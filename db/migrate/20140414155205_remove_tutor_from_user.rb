class RemoveTutorFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :tutor
  end
end
