class AddIndecesToBlockAvailDates < ActiveRecord::Migration
  def change
    add_index :block_availabilities, :departure_date
    add_index :block_availabilities, :arrival_date
    add_index :block_availabilities, :max_occupancy
  end
end
