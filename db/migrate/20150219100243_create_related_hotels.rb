class CreateRelatedHotels < ActiveRecord::Migration
  def change
    create_table :related_hotels do |t|
      t.references :hotel
      t.integer :related_id
    end

    add_index :related_hotels, :hotel_id
    add_index :related_hotels, [:related_id, :hotel_id], unique: true
  end
end
