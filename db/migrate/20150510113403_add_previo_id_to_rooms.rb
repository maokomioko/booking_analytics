class AddPrevioIdToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :previo_id, :integer
    add_index :rooms, :previo_id
  end
end
