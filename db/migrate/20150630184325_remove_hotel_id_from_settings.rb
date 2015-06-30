class RemoveHotelIdFromSettings < ActiveRecord::Migration
  def change
    remove_column :settings, :hotel_id, :integer
  end
end
