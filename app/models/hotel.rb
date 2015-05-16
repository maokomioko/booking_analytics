# == Schema Information
#
# Table name: hotels
#
#  id           :integer          not null, primary key
#  name         :string
#  hoteltype_id :string
#  city         :string
#  city_id      :string
#  address      :string
#  url          :string
#  exact_class  :float
#  review_score :float
#  zip          :string
#  booking_id   :integer
#  current_job  :string
#  latitude     :decimal(10, 6)
#  longitude    :decimal(10, 6)
#  district     :text             default([]), is an Array
#
# Indexes
#
#  index_hotels_on_booking_id                    (booking_id)
#  index_hotels_on_district                      (district)
#  index_hotels_on_exact_class_and_review_score  (exact_class,review_score)
#  index_hotels_on_latitude_and_longitude        (latitude,longitude)
#

class Hotel < ActiveRecord::Base
  include HotelProperties

  scope :contains_facilities, -> (ids) { includes(:facilities).where(hotel_facilities: { id: ids }) }
  scope :with_facilities, -> (ids) { contains_facilities(ids).select { |h| (ids - h.facilities.map(&:id)).size.zero? } }

  scope :with_stars, -> (rate) { where(exact_class: rate) }
  scope :with_score, -> (score) { where(review_score: score) }
  scope :with_score_gt, -> (score) { where('review_score > ?', score) }
  scope :with_score_lt, -> (score) { where('review_score < ?', score) }

  scope :with_district, -> (districts) {
    where("district && ARRAY[?]", districts)
  }

  has_many :rooms

  has_and_belongs_to_many :related,
                          class_name: 'Hotel',
                          join_table: 'related_hotels',
                          foreign_key: 'hotel_id',
                          association_foreign_key: 'related_id'

  has_and_belongs_to_many :facilities,
                          class_name: 'Facility::Hotel',
                          association_foreign_key: 'hotel_facility_id' # counter as PG trigger

  has_one :channel_manager, foreign_key: :booking_id, primary_key: :booking_id
  has_one :location
  has_one :checkin
  has_one :checkout
  has_one :setting

  after_validation :geocode, if: -> { address.present? }

  geocoded_by :full_address do |obj, result|
    if geo = result.first
      obj.latitude  = geo.latitude
      obj.longitude = geo.longitude

      obj.district = if obj.zip.present?
        begin
          here = HerePlaces::Discover.new.search({
           q: [obj.city, obj.zip].join(', '),
           at: [geo.latitude.to_f, geo.longitude.to_f].join(',')
          })
          [here["search"]["context"]["location"]["address"]["district"]]
        rescue Exception
          geo.districts
        end
      else
        geo.districts
      end
    end
  end

  def self.city_districts(city)
    districts = self.distinct
                    .select('UNNEST(district) as d')
                    .where(city: city)
                    .map(&:d)

    Naturally.sort(districts)
  end

  def class_fallback
    exact_class.to_i == 0 ? 3 : exact_class
  end

  def full_address
    [city, address].reject(&:blank?).join(', ')
  end

  def setting_fallback
    if setting.present?
      setting
    else
      create_setting!(DefaultSetting.for_hotel(self))
      setting
    end
  end
end
