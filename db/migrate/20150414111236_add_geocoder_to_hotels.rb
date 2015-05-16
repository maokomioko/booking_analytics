class AddGeocoderToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :latitude, :decimal, { precision: 10, scale: 6 }
    add_column :hotels, :longitude, :decimal, { precision: 10, scale: 6 }

    remove_column :hotels, :district, :string
    add_column :hotels, :district, :text, array: true, default: []

    add_index :hotels, [:latitude, :longitude]
    add_index :hotels, :district, using: :gin
  end
end
