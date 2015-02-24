class AddBookingIdToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :booking_id, :integer
    add_column :rooms, :booking_hotel_id, :integer

    add_index :rooms, :booking_id
    add_index :rooms, :booking_hotel_id
  end
end
