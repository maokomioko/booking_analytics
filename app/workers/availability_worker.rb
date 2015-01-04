class AvailabilityWorker
  include Celluloid
  include Celluloid::IO

  attr_reader :get_blocks, :get_prices

  def initialize(hotel_ids = nil, block_ids = nil)
    @hotel_ids = hotel_ids
    @block_ids = block_ids
  end

  def split_hotels
    @hotel_ids.split(30)
  end

  def split_blocks
    @block_ids.split(30)
  end

  def get_blocks
    puts "blocks processing..."
    BlockAvailability.for_hotels(@hotel_ids).map(&:id)
  end

  def get_prices
    puts "prices processing..."
    BlockAvailability.get_prices(@block_ids)
  end
end
