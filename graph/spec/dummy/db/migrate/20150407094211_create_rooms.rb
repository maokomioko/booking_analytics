class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :max_price_cents
      t.string :max_price_currency, default: 'EUR'
      t.integer :min_price_cents
      t.string :min_price_currency, default: 'EUR'

      t.integer :booking_id
      t.integer :booking_hotel_id

      t.belongs_to :hotel

      t.timestamps
    end
  end
end
