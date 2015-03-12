class Facility::Hotel < ActiveRecord::Base
  include FacilityMethods

  BASE_FACILITY_CACHE_KEY = 'hotel:base_facilities'

  has_and_belongs_to_many :hotels,
                          join_table: 'hotel_facilities_hotels',
                          class_name: '::Hotel',
                          foreign_key: 'hotel_facility_id',
                          association_foreign_key: 'hotel_id'

  after_save :clear_base_facility_cache, if: -> { Hotel::BASE_FACILITIES.include?(name) }

  private

  def clear_base_facility_cache
    Rails.cache.delete(BASE_FACILITY_CACHE_KEY)
  end
end
