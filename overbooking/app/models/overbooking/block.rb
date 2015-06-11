module Overbooking
  class Block < ActiveRecord::Base
    self.table_name = :active_block_availabilities

    scope :today, -> {
      today = Date.tomorrow
      where("(data->>'arrival_date')::date <= ?", today).
        where("(data->>'departure_date')::date > ?", today)
    }

    scope :for_hotels, -> (hotel_ids) { where("(data->>'hotel_id')::integer IN (?)", hotel_ids) }

    scope :with_occupancy_gt, -> (occupancy) do
      occupancy = occupancy.to_i
      max_occupancy = occupancy + 20
      occupancy_string = '"' + (occupancy..max_occupancy).to_a.join('","') + '"'
      where("data @@ 'block.#(max_occupancy IN(#{ occupancy_string }))'")
    end

    def with_max_occupancy(people)
      arr = []
      [].push(self).flatten.each do |block_availability|
        block_availability.data['block'].each do |block|
          occupancy = block['max_occupancy'].to_i

          if occupancy >= people.to_i
            arr << block
          end
        end
      end

      arr
    end
  end
end