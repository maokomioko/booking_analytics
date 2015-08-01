class AddManualToRelatedHotels < ActiveRecord::Migration
  def change
    add_column :related_hotels, :added_manually, :boolean, default: false
  end
end
