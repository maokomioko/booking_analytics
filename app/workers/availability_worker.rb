class AvailabilityWorker
  include Celluloid
  include Celluloid::IO

  attr_reader :get_blocks, :get_prices

  def initialize
  end

  def get_blocks(ids)
    puts "blocks processing..."
    BlockAvailability.for_hotels(ids).map(&:id)
  end

  def get_prices(ids)
    puts "prices processing..."
    BlockAvailability.get_prices(ids)
  end
end
