class AddUniqueKeyToRoomPrices < ActiveRecord::Migration
  def change
    add_index :room_prices, [:date, :room_id], unique: true
    add_index :block_availabilities, [:hotel_id, :departure_date]
  end
end
