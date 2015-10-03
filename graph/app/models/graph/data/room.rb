module Graph
  class Data
    class Room < Data
      attr_accessor :rooms

      def initialize(room_ids, related_booking_ids, period)
        super(period)
        @rooms = Graph.room.includes(:room_prices).where('rooms.id IN (?) OR rooms.booking_hotel_id IN (?)', room_ids, related_booking_ids)
                   .where(room_prices: { date: period })
                   .order("room_prices.date ASC")
      end

      def merged
        xkeys + ykeys
      end

      def ykeys
        room_prices_by_date
      end

      def labels
        super + @rooms.collect{|x| [x.name, Hotel.find_by(booking_id: x.booking_hotel_id).name]}
      end

      private

      def room_prices_by_date
        parent_arr = [].tap do |parent|
          @rooms.each do |room|
            values_arr = [].tap do |values|
              values << "#{Hotel.find_by(booking_id: room.booking_hotel_id).try(:name)} (#{room.name})"
              values << room.room_prices.map(&:price)
            end
            parent << values_arr.flatten
          end

          parent
        end

        parent_arr
      end
    end
  end
end
