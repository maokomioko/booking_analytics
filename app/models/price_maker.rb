class PriceMaker
  include Celluloid

  HOTELS_PER_PAGE = 15

  def initialize(hotel_id, arrival, departure)
    @hotel_id = hotel_id
    @arrival = arrival
    @departure = departure

    safe_init
  end

  def safe_init
    min_price_listing
    split_chunks
    get_top_prices
  end

  protected

  def get_top_prices
    prices = []
    @chunks.first(3).each do |x|
      prices << x[0..2]
    end

    prices
  end

  def split_chunks
    @chunks = @price_blocks.each_slice(HOTELS_PER_PAGE).to_a
  end

  def min_price_listing
    hotel_ids = BlockAvailability.blocks_for_date(@arrival, @departure)
    puts '=== HOTELS ==='
    puts hotel_ids
    puts '======='
    filtered_hotel_ids = Hotel.find(@hotel_id).amenities_calc(hotel_ids)

    puts '=== FILTERED HOTELS ==='
    puts filtered_hotel_ids
    puts '======='

    blocks_arr = []

    filtered_hotel_ids.to_a.split(30).pmap do |i|
      blocks_arr << AvailabilityWorker.new(i).get_blocks
    end

    blocks_arr = blocks_arr.flatten!.uniq!

    price_blocks = []

    blocks_arr.split(30).pmap do |i|
      price_blocks << AvailabilityWorker.new(nil, i).get_prices
    end

    @price_blocks = price_blocks.flatten!.uniq!
  end
end
