class PriceMaker
  using Powerset

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
    filtered_hotel_ids = Hotel.find(@hotel_id).amenities_mix(hotel_ids)

    puts '=== FILTERED HOTELS ==='
    puts filtered_hotel_ids
    puts '======='
    blocks = BlockAvailability.for_hotels(filtered_hotel_ids)

    puts '=== BLOCKS ==='
    puts blocks
    puts '======'
    @price_blocks = BlockAvailability.get_prices(blocks)
  end
end
