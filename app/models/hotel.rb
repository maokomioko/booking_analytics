class Hotel < ActiveRecord::Base
  include ParamSelectable

  scope :contains_facilities, -> (ids){ includes(:facilities).where(hotel_facilities: { id: ids }) }
  scope :with_facilities, -> (ids){ contains_facilities(ids).select{|h| (ids - h.facilities.map(&:id)).size.zero? } }

  scope :with_stars, -> (rate){ where(exact_class: rate) }
  scope :with_score_gt, -> (score){ where("review_score > ?", score) }
  scope :with_score_lt, -> (score){ where("review_score < ?", score) }
  scope :property_type, -> (type_id){ where(hoteltype_id: type_id) }

  has_many :rooms
  has_many :block_availabilities

  has_and_belongs_to_many :related,
                          class_name: 'Hotel',
                          join_table: :related_hotels,
                          foreign_key: :hotel_id,
                          association_foreign_key: :related_id

  has_and_belongs_to_many :facilities, class_name: 'Facility::Hotel', association_foreign_key: 'hotel_facility_id' # counter as PG trigger

  has_one :location
  has_one :checkin
  has_one :checkout

  def amenities_calc
    if related_ids.blank?
      hw_pool = HotelWorker.pool(size: 8)
      n = 2**validate_amenities.size - 1

      results = n.times.map do |i|
        begin
          hw_pool.future.amenities_mix(hotel_id, exact_class, review_score.to_i, i)
        rescue DeadActorError
        end
      end

      unless results.blank?
        self.related_ids = results.map(&:value).flatten!.uniq!.compact
      end
    end
    related_ids
  end

  def validate_amenities
    arr = []

    facilities.each do |f|
     arr << f.id if Hotel.base_facilities.include? f
    end

    arr
  end
end
