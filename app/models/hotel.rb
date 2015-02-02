class Hotel
  include MongoWrapper
  include ParamSelectable
  include Celluloid

  scope :contains_facilities, -> (keywords){ self.in(facilities: keywords) }
  scope :with_facilities, -> (keywords){ all_in(facilities: keywords) }

  scope :with_stars, -> (rate){ where(exact_class: rate) }
  scope :with_score_gt, -> (score){ self.gt(review_score: score) }
  scope :with_score_lt, -> (score){ self.lt(review_score: score) }
  scope :property_type, -> (type_id){ where(hoteltype_id: type_id) }

  has_many :rooms, foreign_key: :hotel_id
  has_many :block_availabilities

  has_and_belongs_to_many :hotels, class_name: 'Hotel', inverse_of: :related_hotels
  has_and_belongs_to_many :related_hotels, class_name: 'Hotel', inverse_of: :hotels

  embeds_one :location
  embeds_one :checkin
  embeds_one :checkout

  field :hotel_id, type: String
  field :_id, type: String, default: -> { hotel_id.to_s.parameterize }
  index({ hotel_id: 1 }, { background: true })

  field :name
  field :hoteltype_id

  field :city
  field :city_id
  field :address
  field :url

  field :facilities, type: Array

  field :exact_class, type: Float
  field :review_score, type: Float

  field :district
  field :zip

  def amenities_calc
    if hotel_ids.blank?
      hw_pool = HotelWorker.pool(size: 8)
      n = 2**validate_amenities.size - 1

      results = n.times.map do |i|
        begin
          hw_pool.future.amenities_mix(hotel_id, exact_class, i)
        rescue DeadActorError
        end
      end

      unless results.blank?
        update_attribute(:hotel_ids, results.map(&:value).flatten!.uniq!.compact)
      end
    end
    hotel_ids
  end

  def validate_amenities
    arr = []

    facilities.each do |f|
     arr << f if Hotel.base_facilities.include? f
    end

    arr
  end

  class << self
    def remap_with_ids
      arr = []

      Hotel.each do |hotel|
        arr << hotel.hotel_id
      end

      arr.each do |arr_el|
        hotel = Hotel.find_by(hotel_id: arr_el)
        up_hotel = Hotel.new({
          hotel_id: hotel.hotel_id,
          name: hotel.name,
          hoteltype_id: hotel.hoteltype_id,
          city: hotel.city,
          city_id: hotel.city_id,
          address: hotel.address,
          url: hotel.url,
          facilities: hotel.facilities,
          exact_class: hotel.exact_class,
          review_score: hotel.review_score,
          district: hotel.district,
          zip: hotel.zip
        })
        up_hotel.save!

        unless hotel.location.nil?
          location = Location.new
          location.latitude = hotel.location.latitude
          location.longitude = hotel.location.longitude
          up_hotel.location = location
        end

        hotel.destroy!
      end
    end
  end
end

class Location
  include MongoWrapper
  embedded_in :hotel

  field :latitude
  field :longitude
end

class Checkin
  include MongoWrapper
  embedded_in :hotel

  field :to
  field :from
end

class Checkout
  include MongoWrapper
  embedded_in :hotel
  field :to
  field :from
end
