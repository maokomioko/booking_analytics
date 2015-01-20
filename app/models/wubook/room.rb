class Wubook::Room
  include MongoWrapper

  belongs_to :wubook_auth
  has_many :room_prices

  field :wubook_auth_id, type: String
  field :room_id, type: String

  index({ wubook_auth_id: 1 }, { background: true })
  index({ room_id: 1 }, { background: true })

  field :name, type: String
  field :max_people, type: Integer

  field :availability, type: Integer
  field :occupancy, type: Integer
  field :price, type: Float

  field :subroom, type: Integer
  field :children, type: Integer

  def recommended_price(date)
    begin
      date = date.strftime("%Y-%m-%d")
      room_prices.find_by(date: date).price
    rescue
      0
    end
  end

  def fill_prices(dates = nil)
    dates = [*Date.today..Date.today + 5.days]
    # dates.each do |date|
    #   PriceMaker.new(wubook_auth.lcode, date, date + 1.day)
    # end

    dates.each do |date|
      RoomPrice.create(room_id: id,
                       date: date.strftime("%Y-%m-%d"),
                       price: Random.rand(10)
                       )
    end
  end
end
