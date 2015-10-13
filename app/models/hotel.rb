# == Schema Information
#
# Table name: hotels
#
#  id              :integer          not null, primary key
#  name            :string
#  hoteltype_id    :string
#  city            :string
#  city_id         :string
#  address         :string
#  url             :string
#  exact_class     :float
#  review_score    :float
#  zip             :string
#  booking_id      :integer
#  latitude        :decimal(10, 6)
#  longitude       :decimal(10, 6)
#  district        :string           default("{}")
#  website_url     :string
#  phone           :string
#  normalized_name :string
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

  scope :with_district, -> (districts) { where(district: districts) }

  scope :full_text_search, -> (query) {
    return none if query.empty? || query.length < 3

    query = Hotel.prepare_fts_query(query)
    fields = %w(name normalized_name booking_id address district).join(', ')
    where("to_tsvector(concat_ws(' ', #{ fields })) @@ to_tsquery(?)", query)
  }

  has_many :channel_managers, foreign_key: :booking_id, primary_key: :booking_id
  has_many :rooms, foreign_key: :booking_hotel_id, primary_key: :booking_id

  has_many :contacts

  has_many :related_hotels
  has_many :related,
           through: :related_hotels,
           class_name: 'Hotel'

  has_and_belongs_to_many :facilities,
                          class_name: 'Facility::Hotel',
                          association_foreign_key: 'hotel_facility_id' # counter as PG trigger

  has_one :location
  has_one :checkin
  has_one :checkout

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
          here["search"]["context"]["location"]["address"]["district"]
        rescue Exception
          geo.districts[0] rescue ''
        end
      else
        geo.districts[0] rescue ''
      end
    end
  end

  def self.city_districts(city)
    districts = Hotel.distinct.where(city: city).pluck(:district)
    Naturally.sort(districts)
  end

  def self.prepare_fts_query(query)
    query = query.split(' ')
    query[query.length - 1] += ':*'
    query.join(' & ')
  end

  def district
    atr = read_attribute(:district)
    update_attribute(:district, geocode) if atr.blank?

    atr ||= read_attribute(:district)
  end

  def class_fallback
    exact_class.to_i == 0 ? 3 : exact_class
  end

  def full_address
    [city, address].reject(&:blank?).join(', ')
  end

  def post_address
    [zip, city, district, address].reject(&:blank?).join(', ')
  end
end
