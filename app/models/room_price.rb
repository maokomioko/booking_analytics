# == Schema Information
#
# Table name: room_prices
#
#  id            :integer          not null, primary key
#  date          :date
#  default_price :float
#  price         :float
#  enabled       :boolean
#  locked        :boolean
#  room_id       :integer
#
# Indexes
#
#  index_room_prices_on_date_and_room_id  (date,room_id) UNIQUE
#

class RoomPrice < ActiveRecord::Base
  belongs_to :room

  scope :within_dates, -> (dates) { where(date: dates) } do
    def date_groupped
      each_with_object({}) do |rp, hash|
        hash[rp.date] ||= []
        hash[rp.date] << rp
      end
    end
  end

  before_save :set_default_price

  def set_default_price
    self.default_price ||= 0
  end
end
