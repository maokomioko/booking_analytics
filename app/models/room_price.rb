class RoomPrice < ActiveRecord::Base
  belongs_to :room, class_name: 'Wubook::Room'

  scope :within_dates, -> (dates){ where(date: dates)}
end
