class PriceMaker
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
    puts 'HOTELS with free blocks to date... Done!'
    filtered_hotel_ids = Hotel.find(@hotel_id).amenities_calc(hotel_ids)

    puts 'Hotels with amenities... Done!'

    blocks_arr = []

    filtered_hotel_ids.to_a.each_slice(30).to_a.pmap do |i|
      blocks_arr << AvailabilityWorker.new(i).get_blocks
    end

    puts 'Filtered blocks for those hotels... Done!'

    blocks_arr = blocks_arr.flatten!.uniq!

    price_blocks = []

    blocks_arr.each_slice(30).to_a.pmap do |i|
      price_blocks << AvailabilityWorker.new(nil, i).get_prices
    end

    puts 'Ordered prices... Done!'

    @price_blocks = price_blocks.flatten!.uniq!
  end
end
