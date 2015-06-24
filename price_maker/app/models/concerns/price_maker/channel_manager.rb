##
## Concern for Room
##
module PriceMaker
  module ChannelManager
    extend ActiveSupport::Concern

    included do
      scope :real, -> { where(subroom: nil) }

      def fill_prices(setting_id)
        hotel_room_ids = matching_hotels

        if hotel_room_ids
          desired_position = RoomSetting.where(setting_id: setting_id, room_id: id).pluck(:position).first || 1
          dates = [*Date.today..Date.today + 3.month]
          dates.each do |date|
            begin
              price = PriceMaker::Algorithm.new(hotel_room_ids, max_people_fallback, date, date + 1.day, desired_position).best_price
              # be aware, that prices are in cents

              rp = RoomPrice.find_or_initialize_by(date: date, room: self)
              rp.default_price_cents = 0 if rp.default_price_cents.nil?

              if max_price_cents > 0 && price > max_price_cents
                price = max_price_cents
              end

              if min_price_cents > 0 && price < min_price_cents
                price = min_price_cents
              end

              rp.price_cents = price * 100

              rp.save! unless rp.locked == true
            rescue
              puts 'Empty result'
            end
          end
        end
      end

      private

      # returns Array
      # [ [hotel_booking_id, [room_booking_id, room_booking_id]], [hotel_booking_id, []] ]
      def matching_hotels
        if hotel.get_base_facilities.size > 0
          booking_ids = hotel.amenities_calc
          room_ids    = amenities_calc
          Hotel
            .includes(:rooms)
            .where(booking_id: booking_ids)
            .where(rooms: { roomtype: roomtype, max_people: max_people, id: room_ids })
            .pluck('hotels.booking_id', 'rooms.booking_id')
            .inject({}) do |hash, value|
              # 0 - hotel, 1 - room
              hash[value[0]] ||= []
              hash[value[0]] << value[1]
              hash
            end.to_a
        else
          nil
        end
      end

      def format_date(date)
        date.strftime('%Y-%m-%d')
      end
    end
  end
end
