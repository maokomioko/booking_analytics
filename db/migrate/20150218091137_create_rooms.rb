class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :max_persons
      t.string :roomtype
      t.float :max_price
      t.float :min_price

      t.belongs_to :hotel
    end

    add_index :rooms, :hotel_id
  end
end
