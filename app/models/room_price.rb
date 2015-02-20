class RoomPrice < ActiveRecord::Base
  belongs_to :room

  scope :within_dates, -> (dates){ where(date: dates)}
end
