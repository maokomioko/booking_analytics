class CleanupRoomFields < ActiveRecord::Migration
  def change
    remove_column :rooms, :occupancy
    remove_column :rooms, :children
    remove_column :rooms, :availability
  end
end
