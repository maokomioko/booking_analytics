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
#  channel_manager_id :integer
#  subroom            :integer
#  max_people         :integer
#  price              :float
#  min_price_currency :string           default("EUR")
#  max_price_currency :string           default("EUR")
#  booking_id         :integer
#  booking_hotel_id   :integer
#  previo_id          :integer
#
# Indexes
#
#  index_rooms_on_booking_hotel_id    (booking_hotel_id)
#  index_rooms_on_booking_id          (booking_id)
#  index_rooms_on_channel_manager_id  (channel_manager_id)
#  index_rooms_on_hotel_id            (hotel_id)
#  index_rooms_on_previo_id           (previo_id)
#  index_rooms_on_roomtype            (roomtype)
#

class Room < ActiveRecord::Base
  include RoomProperties
  include PriceMaker::RoomAmenities
  include PriceMaker::ChannelManager

  scope :contains_facilities, -> (ids) { includes(:facilities).where(room_facilities: { id: ids }) }
  scope :with_facilities, -> (ids) { contains_facilities(ids).select { |h| (ids - h.facilities.map(&:id)).size.zero? } }

  belongs_to :hotel

  has_many :room_prices, dependent: :destroy

  has_and_belongs_to_many :facilities,
                          class_name: 'Facility::Room',
                          association_foreign_key: 'room_facility_id' # counter as PG trigger
  # has_and_belongs_to_many :wubook_auths

  has_one :bedding

  monetize :min_price_cents
  monetize :max_price_cents

  def occupancy_fallback
    occupancy.to_i == 0 ? 1 : occupancy
  end

  def max_people_fallback
    max_people.to_i == 0 ? 1 : max_people
  end

  def name
    self[:name] ||
      self[:roomtype].to_s + " (#{self[:max_people]} people)"
  end
end
