class AddHotelToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :hotel_id, :integer
    add_index :settings, :hotel_id
  end
end
