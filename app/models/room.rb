# == Schema Information
#
# Table name: rooms
#
#  id                 :integer          not null, primary key
#  roomtype           :string
#  max_price_cents    :integer
#  min_price_cents    :integer
#  hotel_id           :integer
#  name               :string
#  availability       :integer
#  occupancy          :integer
#  children           :integer
#  wubook_auth_id     :integer
#  subroom            :integer
#  max_people         :integer
#  price              :float
#  min_price_currency :string           default("EUR")
#  max_price_currency :string           default("EUR")
#  booking_id         :integer
#  booking_hotel_id   :integer
#

class Room < ActiveRecord::Base
  include PriceMaker::Wubook

  scope :with_facilities, -> (ids){
    includes(:facilities).where(room_facilities: { id: ids })
        .select{|h| (ids - h.facilities.map(&:id)).size.zero? }
  }

  belongs_to :hotel

  has_many :room_prices, dependent: :destroy

  has_and_belongs_to_many :facilities, class_name: 'RoomFacility' # counter as PG trigger
  has_and_belongs_to_many :wubook_auths

  has_one :bedding

  monetize :min_price_cents
  monetize :max_price_cents

  def occupancy_fallback
    occupancy.to_i == 0 ? 1 : occupancy
  end
end
