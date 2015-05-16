require 'block_availability'

class PriceMaker::AvailabilityWorker
  include Celluloid

  attr_reader :get_blocks, :get_prices

  def initialize
  end

  def get_block_prices(hotel_room_ids, occupancy, arrival, departure)
    puts 'Room Booking IDS '.green + hotel_room_ids.to_s
    hotel_room_hash = Hash[hotel_room_ids] # { hotel_id: [room_id, room_id] }

    blocks = BlockAvailability.for_hotels(hotel_room_hash.keys)
             .by_arrival(arrival).by_departure(departure)

    arr = []
    blocks.each do |block|
      arr << block.block_prices(occupancy, hotel_room_hash[block.data['hotel_id'].to_i], 0)
    end

    arr.flatten.sort
  end
end
