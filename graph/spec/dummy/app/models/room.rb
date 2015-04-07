class Room < ActiveRecord::Base
  belongs_to :hotel

  has_many :room_prices
end