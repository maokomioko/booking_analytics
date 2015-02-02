class Wubook::Room
  include MongoWrapper

  belongs_to :wubook_auth
  has_many :room_prices, dependent: :destroy

  scope :real, -> { self.in(subroom: [0, '', nil]) }

  field :wubook_auth_id, type: String
  field :room_id, type: Integer

  index({ wubook_auth_id: 1 }, { background: true })
  index({ room_id: 1 }, { background: true })

  field :name, type: String
  field :max_people, type: Integer

  field :availability, type: Integer
  field :occupancy, type: Integer
  field :price, type: Float

  field :subroom, type: Integer
  field :children, type: Integer

  def fill_prices
    hotel_ids = Hotel.find(wubook_auth.booking_id).amenities_calc
    dates = [*Date.today..Date.today + 3.month]
    dates.each do |date|
      begin
        price = PriceMaker.new(hotel_ids, 1, date, date + 1.day).get_top_prices
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
