module Overbooking
  class BlockExtractor
    attr_accessor :blocks

    def initialize(blocks)
      @blocks = blocks
    end

    def hotel_hash
      @blocks.each_with_object({}) do |block, hash|
        hash[block.data['hotel_id']] = block
      end
    end

    def booking_ids
      @blocks.map do |b|
        b.data['hotel_id']
      end.uniq
    end

    #
    # Returns Array with 2 elements
    # [0] - blocks with min_price less than or equal to +price+
    # [1] - blocks with min_price more than +price+
    #
    # +sort+ - Boolean. Sort by price. Cheaper first
    #
    # Array element schema:
    #  booking_id: {
    #    room: Overbooking::Block.data['block'][],
    #    block: Overbooking::Block
    #    hotel: {
    #      booking_id: Overbooking::Hotel.booking_id,
    #      name: Overbooking::Hotel.name,
    #      address: Overbooking::Hotel.address
    #    }
    # }
    #
    def divide_by_money_and_occupancy(price, occupancy, sort = true)
      hotels = Overbooking::Hotel.where(booking_id: booking_ids).each_with_object({}) do |hotel, hash|
        hash[hotel.booking_id.to_s] = hotel
      end

      result = @blocks.each_with_object([]) do |block, array|
        array[0] ||= {} # cheap rooms
        array[1] ||= {} # expensive rooms

        hotel = hotels[block.data['hotel_id']] || OpenStruct.new({
          booking_id: block.data['hotel_id'],
          name: "Undefined hotel (Booking ID: #{ block.data['hotel_id'] })",
          address: ''
        })

        block.with_max_occupancy(occupancy).each do |room|
          min_price = room['min_price']['price'].to_f

          result_object = {
            room: room,
            block: block,
            hotel: {
              booking_id: hotel.booking_id,
              name: hotel.name,
              address: hotel.address
            }
          }

          if price >= min_price
            array[0][hotel.booking_id] ||= []
            array[0][hotel.booking_id] << result_object
          else
            array[1][hotel.booking_id] ||= []
            array[1][hotel.booking_id] << result_object
          end
        end
      end

      if sort
        result.each_with_index do |part, i|
          part.each do |k, _block|
            result[i][k].sort_by! { |v| v[:room]['min_price']['price'].to_f }
          end
        end
      end

      result
    end
  end
end
