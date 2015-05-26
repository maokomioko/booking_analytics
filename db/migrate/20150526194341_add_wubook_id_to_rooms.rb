class AddWubookIdToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :wubook_id, :integer
  end
end
