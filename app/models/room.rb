# == Schema Information
#
# Table name: rooms
#
#  id                 :integer          not null, primary key
#  roomtype           :string
#  max_price          :float
#  min_price          :float
#  hotel_id           :integer
#  name               :string
#  channel_manager_id :integer
#  subroom            :integer
#  max_people         :integer
#  price              :float
#  booking_id         :integer
#  booking_hotel_id   :integer
#  previo_id          :integer
#  wubook_id          :integer
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

  belongs_to :hotel, foreign_key: :booking_hotel_id, primary_key: :booking_id

  has_many :room_prices, dependent: :destroy
  has_many :room_settings, dependent: :destroy

  has_and_belongs_to_many :facilities,
                          class_name: 'Facility::Room',
                          association_foreign_key: 'room_facility_id' # counter as PG trigger

  has_one :bedding

  after_create :create_room_settings

  validates_numericality_of :min_price, greater_than_or_equal_to: 0
  validate :validate_max_price
  validates_uniqueness_of :booking_id, scope: :hotel_id, allow_blank: true

  def max_people_fallback
    max_people.to_i == 0 ? 1 : max_people
  end

  def name
    self[:name] || self[:roomtype].to_s + " (#{self[:max_people]} people)"
  end

  private

  def validate_max_price
    if max_price < min_price
      errors.add(:max_price, :greater_than_or_equal_to, count: min_price.to_s)
    end
  end

  def create_room_settings
    Setting.where(hotel_id: room.hotel_id).find_each do |setting|
      RoomSetting.create(
        setting: setting,
        room: self,
        position: 1
      )
    end
  end
end
