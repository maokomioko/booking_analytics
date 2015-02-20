class AddBookingIdToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :booking_id, :integer
    add_index :hotels, :booking_id
  end
end
