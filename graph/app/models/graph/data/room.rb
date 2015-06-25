module Graph
  class Data
    class Room < Data
      attr_accessor :rooms

      def initialize(room_ids, period)
        super(period)
        @rooms = Graph.room.includes(:room_prices).where(id: room_ids)
                   .where(room_prices: { date: period })
                   .order("room_prices.date ASC")
      end

      def data
        prices = room_prices_by_date

        super.map do |old_hash|
          date = old_hash[:day]

          old_hash.deep_merge(@rooms.map(&:id).inject({}) do |hash, room_id|
            hash[room_id] = prices[room_id][date]
            hash
          end)
        end
      end

      def ykeys
        super + @rooms.map(&:id)
      end

      def labels
        super + @rooms.map(&:name)
      end

      private

      # { %room_id%: { %date%: %price% } }
      def room_prices_by_date
        @rooms.inject({}) do |hash, room|
          hash[room.id] ||= {}
          room.room_prices.each do |price|
            hash[room.id][price.date.strftime(Graph::Data.date_format)] =
              price.price
          end

          hash
        end
      end
    end
  end
end
