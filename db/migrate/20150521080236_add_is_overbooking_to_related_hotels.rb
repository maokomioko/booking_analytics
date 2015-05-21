class AddIsOverbookingToRelatedHotels < ActiveRecord::Migration
  def change
    add_column :related_hotels, :is_overbooking, :boolean, default: false
  end
end
