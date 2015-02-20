module WubookRoom
  extend ActiveSupport::Concern

  included do
    scope :real, -> { where(subroom: nil) }

    def fill_prices
      hotel_ids = Hotel.find(wubook_auth.booking_id).amenities_calc
      dates = [*Date.today..Date.today + 3.month]
      dates.each do |date|
        begin
          price = PriceMaker.new(hotel_ids, occupancy, date, date + 1.day).get_top_prices
          rp = room_prices.find_by(date: date)
          rp.update_attribute(:price, price.second.first) unless rp.locked
        rescue
          puts "No price"
        end
      end
    end

    private

    def format_date(date)
      date.strftime("%Y-%m-%d")
    end
  end
end