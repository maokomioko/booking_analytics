class RoomPrice < ActiveRecord::Base
  belongs_to :room

  monetize :default_price_cents
  monetize :price_cents

  scope :within_dates, -> (dates){ where(date: dates)}

  before_save :set_default_price

  def set_default_price
    self.default_price_cents ||= 0
  end
end
