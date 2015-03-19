require 'block_availability'

class PriceMaker::AvailabilityWorker
  include Celluloid

  attr_reader :get_blocks, :get_prices

  def initialize
  end

  def get_block_prices(hotel_ids, occupancy, arrival, departure)
    blocks = BlockAvailability.for_hotels(hotel_ids).
              by_arrival(arrival).by_departure(departure).with_occupancy(occupancy).limit(60)

    arr = []
    blocks.each do |block|
      arr << block.block_prices(occupancy, 0)
    end

    arr.flatten.sort
  end
end
