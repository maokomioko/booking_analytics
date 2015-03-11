class BlockAvailabilityParser
  def initialize(block_availability)
    raise 'Object must be a type of BlockAvailability' unless block_availability.is_a?(BlockAvailability)
    @object = block_availability
    @json   = @object.data
  end

  # parse JSON data and update object with relations
  def parse
    ActiveRecord::Base.transaction do
      @json['block'].each do |json_block|
        block = parse_block(json_block)
        parse_incremental_prices(block.id, json_block['incremental_price'])
      end

      %w(departure_date arrival_date).each do |field|
        if @json[field].present?
          @object.send(field + '=', @json[field]) rescue nil
        end
      end

      @object.booking_id = @json['hotel_id']

      hotel = Hotel.find_by_booking_id(@json['hotel_id'])
      if hotel.present?
        @object.hotel_id = hotel.id
      end

      @object.save
    end
  end

  private

  # parse and update Block relations
  def parse_block(json)
    block = Block.find_or_create_by(block_id: json['block_id'], block_availability: @object)

    # boolean fields
    %w(refundable deposit_required breakfast_included).each do |field|
      if json[field].present?
        block.send(field + '=', json[field].to_i == 1) rescue nil
      end
    end

    %w(refundable_until max_occupancy).each do |field|
      if json[field].present?
        block.send(field + '=', json[field]) rescue nil
      end
    end

    block.save
    block
  end

  # parse and update Block -> IncrementalPrice relations
  def parse_incremental_prices(block_id, json_prices)
    IncrementalPrice.delete_all(block_id: block_id) # remove old prices

    json_prices.each do |price|
      IncrementalPrice.create(
          block_id: block_id,
          price: Money.new(price['price'].to_money, price['currency'])
      )
    end
  end
end