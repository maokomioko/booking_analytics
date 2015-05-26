module Overbooking
  class Block < ActiveRecord::Base
    self.table_name = :active_block_availabilities

    scope :today, -> {
      today = Date.tomorrow
      where("(data->>'arrival_date')::date <= ?", today).
        where("(data->>'departure_date')::date > ?", today)
    }

    scope :for_hotels, -> (hotel_ids) { where("(data->>'hotel_id')::integer IN (?)", hotel_ids) }
  end
end