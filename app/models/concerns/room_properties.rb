module RoomProperties
  extend ActiveSupport::Concern

  BASE_FACILITIES = [
    'Air conditioning',
    'Bathtub',
    'Flat-screen TV',
    'Kitchen',
    'Kitchenette',
    'Patio',
    'Private pool',
    'Soundproof',
    'Spa tub',
    'Terrace',
    'View',
    'Washing machine'
  ]

  module ClassMethods
    def base_facilities
      Facility::Room.where(name: BASE_FACILITIES)
    end

    def base_facilities_cache
      Rails.cache.fetch(Facility::Room::BASE_FACILITY_CACHE_KEY) do
        base_facilities.load
      end
    end
  end
end
