class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :latitude
      t.string :longitude
      t.belongs_to :hotel
    end

    add_index :locations, :hotel_id
  end
end
