module PriceMaker
  module ChannelManager
    extend ActiveSupport::Concern

    included do
      scope :real, -> { where(subroom: nil) }

      def fill_prices
        hotel_ids = matching_hotels

        if hotel_ids
          dates = [*Date.today..Date.today + 3.month]
          dates.each do |date|
            begin
              price = PriceMaker::Algorithm.new(hotel_ids, occupancy_fallback, date, date + 1.day).get_top_prices
              #be aware, that prices are in cents

              rp = RoomPrice.find_or_initialize_by(date: date, price_cents: Money.new(price.second.first), room: self)

              rp.price = Money.new(price.second.first)
              rp.save! unless rp.locked == true
            rescue
              puts "Empty result"
            end
          end
        end
      end

      private

      def matching_hotels
        if hotel.validate_amenities.size > 0
          hotel.amenities_calc
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
