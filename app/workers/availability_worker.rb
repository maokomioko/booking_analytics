class AvailabilityWorker
  include Celluloid
  include Celluloid::IO

  attr_reader :get_blocks, :get_prices

  def initialize
  end

  def get_blocks(hotel_ids, arrival, departure)
    puts "blocks processing..."
    BlockAvailability.to_date(hotel_ids, arrival, departure)
  end

  def get_prices(ids)
    puts "prices processing..."
    BlockAvailability.get_prices(ids)
  end
end
