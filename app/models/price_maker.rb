class PriceMaker
  HOTELS_PER_PAGE = 15

  attr_reader :get_top_prices, :min_price_listing

  def initialize(hotel_id, arrival, departure)
    @hotel_id = hotel_id
    @arrival = arrival
    @departure = departure

    #safe_init
  end

  # def safe_init
  #   min_price_listing
  #   split_chunks
  #   get_top_prices
  # end

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

    aw_pool = AvailabilityWorker.pool(size: 4)
    begin
      blocks = filtered_hotel_ids.to_a.limit(10).to_a.map do |i|
        aw_pool.future.get_blocks(i)
      end

      blocks = blocks.map(&:value).flatten!.uniq!
      puts 'Filtered blocks for those hotels... Done!'
    rescue
      puts 'Actor has crashed'
    end


    pr_pool = AvailabilityWorker.pool(size: 4)
    begin
      pr_blocks = blocks.limit(10).map do |i|
        pr_pool.future.get_prices(i)
      end

      pr_blocks = pr_blocks.map(&:value).flatten!.uniq!
      puts 'Ordered prices... Done!'
    rescue
      'Actor has crashed'
    end


    @price_blocks = price_blocks.flatten!.uniq!
  end
end
