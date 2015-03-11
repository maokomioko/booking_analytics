module PriceMaker
  module Wubook
    extend ActiveSupport::Concern

    included do
      scope :real, -> { where(subroom: nil) }

      def fill_prices
        hotel_ids = matching_hotels

        if hotel_ids
          dates = [*Date.today..Date.today + 3.month]
          dates.each do |date|
            begin
              price = PriceMaker::Algorithm.new(hotel_ids, occupancy, date, date + 1.day).get_top_prices
              # be aware that prices in cents

              rp = RoomPrice.find_or_initialize_by(date: date, room: self)

              rp.price = Money.new(price.second.first)
              rp.save unless rp.locked
            rescue
              puts "No price"
            end
          end
        end
      end

      private

      def current_hotel
        # Hotel.find(wubook_auths.first.booking_id)
        hotel
      end

      def matching_hotels
        if current_hotel.validate_amenities.size > 0
          current_hotel.amenities_calc
        else
          nil
        end
      end

      def format_date(date)
        date.strftime("%Y-%m-%d")
      end
    end
  end
end
