class CreateRoomPrices < ActiveRecord::Migration
  def change
    create_table :room_prices do |t|
      t.integer :room_id
      t.date :date
      t.integer :price_cents
      t.string :price_currency, default: 'EUR'
    end
  end
end
