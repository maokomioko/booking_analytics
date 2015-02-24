class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :hoteltype_id

      t.string :city
      t.string :city_id
      t.string :address
      t.string :url

      t.float :exact_class
      t.float :review_score

      t.string :district
      t.string :zip
    end
  end
end
