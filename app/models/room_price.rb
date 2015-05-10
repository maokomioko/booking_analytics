# == Schema Information
#
# Table name: room_prices
#
#  id                     :integer          not null, primary key
#  date                   :date
#  default_price_cents    :integer
#  price_cents            :integer
#  enabled                :boolean
#  locked                 :boolean
#  room_id                :integer
#  price_currency         :string           default("EUR")
#  default_price_currency :string           default("EUR")
#
# Indexes
#
#  index_room_prices_on_date_and_room_id  (date,room_id) UNIQUE
#

class RoomPrice < ActiveRecord::Base
  belongs_to :room

  monetize :default_price_cents, allow_nil: true
  monetize :price_cents, allow_nil: true

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
    self.default_price_cents ||= 0
  end
end
