class PriceMaker
  include Celluloid
  include Celluloid::IO

  HOTELS_PER_PAGE = 15

  attr_reader :get_top_prices, :min_price_listing

  def initialize(hotel_id, arrival, departure)
    @hotel_id = hotel_id
    @arrival = arrival
    @departure = departure

    safe_init
  end

  def safe_init
    min_price_listing
    split_chunks
    #get_top_prices
  end

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
    hotel_ids = Hotel.find(@hotel_id).amenities_calc

    aw_pool = AvailabilityWorker.pool(size: 4)
    h_slices = hotel_ids.to_a.each_slice(30)

    #begin
      blocks = 2.times.map do
        not_blank = h_slices.next.reject(&:blank?)
        aw_pool.future.get_blocks(not_blank, @arrival, @departure)
      end

      blocks = blocks.map(&:value).flatten!
      #puts 'Filtered blocks for those hotels... Done!'
    # rescue
    #   puts 'Blocks Actor has crashed'
    # end

    pr_pool = AvailabilityWorker.pool(size: 4)
    b_slices = blocks.each_slice(30)

    # #begin
      pr_blocks = b_slices.count.times.map do
        pr_pool.future.get_prices(b_slices.next)
      end

      pr_blocks = pr_blocks.map(&:value).flatten!.uniq!
    #   puts 'Ordered prices... Done!'
    # # rescue
    # #   'Prices Actor has crashed'
    # # end

    @price_blocks = pr_blocks
  end
end
