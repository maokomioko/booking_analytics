class CreateRoomPrices < ActiveRecord::Migration
  def change
    create_table :room_prices do |t|
      t.date :date
      t.float :default_price
      t.float :price
      t.boolean :enabled
      t.boolean :locked

      t.integer :room_id
    end
  end
end
