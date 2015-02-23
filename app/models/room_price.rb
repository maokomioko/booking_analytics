class RoomPrice < ActiveRecord::Base
  belongs_to :room

  monetize :default_price_cents
  monetize :price_cents

  scope :within_dates, -> (dates){ where(date: dates)}
end
