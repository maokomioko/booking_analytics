class RemoveHotelNameFromCm < ActiveRecord::Migration
  def change
    remove_column :channel_managers, :hotel_name, :string
  end
end
