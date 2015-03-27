# == Schema Information
#
# Table name: room_facilities
#
#  id    :integer          not null, primary key
#  name  :string
#  count :integer          default(0)
#
# Indexes
#
#  index_room_facilities_on_id  (id) UNIQUE
#

class Facility::Room < ActiveRecord::Base
  include FacilityMethods

  BASE_FACILITY_CACHE_KEY = 'room:base_facilities'

  has_and_belongs_to_many :rooms,
                          join_table: 'room_facilities_rooms',
                          class_name: '::Room',
                          foreign_key: 'room_facility_id',
                          association_foreign_key: 'room_id'

  after_save :clear_base_facility_cache, if: -> { Room::BASE_FACILITIES.include?(name) }

  private

  def clear_base_facility_cache
    Rails.cache.delete(BASE_FACILITY_CACHE_KEY)
  end
end
