module Graph
  module FormHelper
    def options_for_hotels
      current_user.hotels.map do |hotel|
        [hotel.name, hotel.booking_id]
      end
    end

    def options_for_rooms(booking_id)
      hotel = Hotel.find_by_booking_id(booking_id)

      hotel.rooms.map do |room|
        [room.name, room.id]
      end
    end

    def options_for_related(booking_id)
      hotel = Hotel.find_by_booking_id(booking_id)

      hotel.related.map do |related|
        [related.name, related.booking_id]
      end
    end
  end
end