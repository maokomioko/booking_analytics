class CreateBlockAvailabilities < ActiveRecord::Migration
  def change
    create_table :block_availabilities do |t|
      t.string :departure_date
      t.string :arrival_date
      t.string :max_occupancy

      t.jsonb :data

      t.belongs_to :hotel
    end

    add_index :block_availabilities, :hotel_id
  end
end
