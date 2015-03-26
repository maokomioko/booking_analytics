class AddTypeIndexToRooms < ActiveRecord::Migration
  def change
    add_index :rooms, :roomtype
  end
end
