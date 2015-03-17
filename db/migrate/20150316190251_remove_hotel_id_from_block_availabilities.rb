class RemoveHotelIdFromBlockAvailabilities < ActiveRecord::Migration
  def change
    remove_column :block_availabilities, :hotel_id
  end
end
