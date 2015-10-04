module Graph
  class Data
    class Room < Data
      attr_accessor :rooms

      def initialize(room_ids, related_booking_ids, period)
        @dates = super(period)
        @rooms = Graph.room.includes(:room_prices).where(id: room_ids)
                   .where(room_prices: { date: period })
                   .order("room_prices.date ASC")

        @competitors_hotels = Hotel.where(booking_id: related_booking_ids)
      end

      def merged
        xkeys + ykeys
      end

      def ykeys
        prices_by_date + competitors_prices_by_date.compact
      end

      def labels
        super + @rooms.collect{|x| [x.name, Hotel.find_by(booking_id: x.booking_hotel_id).name]}
      end

      private

      def prices_by_date
        parent_arr = [].tap do |parent|
          @rooms.each do |room|
            prices = room.room_prices.map(&:price)
            unless prices.compact.empty?
              values_arr = [].tap do |values|
                values << "#{Hotel.find_by(booking_id: room.booking_hotel_id).try(:name)} (#{room.name})"
                values << prices
              end
              parent << values_arr.flatten
            end
            parent
          end

          parent
        end

        parent_arr
      end
    end

    def competitors_prices_by_date
      occupancy = @rooms.map(&:max_people).sort
      parent_arr = [].tap do |parent|

        @competitors_hotels.each do |hotel|

          rooms = (if occupancy.flatten.compact
                      hotel.rooms.where('max_people IN (?)', occupancy)
                    else
                      hotel.rooms
                    end)

          rooms.each do |room|
            values_arr = [].tap do |values|
                values << "#{hotel.try(:name)} (#{room.name})"
                @dates.each do |date|
                  values << BlockAvailability.for_room_to_date(hotel.booking_id, room.id, date)
                end
            end
            parent << values_arr.flatten.compact
          end
          parent
        end

      end

      parent_arr
    end
  end
end
