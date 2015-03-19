class RemoveDatesFromBlockAvailabilities < ActiveRecord::Migration
  def change
    remove_column :block_availabilities, :departure_date
    remove_column :block_availabilities, :arrival_date
  end
end
