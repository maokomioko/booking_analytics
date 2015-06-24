class DefaultSetting
  attr_accessor :crawling_frequency, :stars, :user_ratings,
                :property_types, :districts, :company_id

  def self.default
    self.new.build
  end

  def self.for_hotel(hotel)
    obj = self.new

    obj.stars = [hotel.exact_class.to_i] if hotel.exact_class
    obj.user_ratings = obj.score_range(hotel.review_score)
    obj.property_types = [ hotel.hoteltype ] if hotel.hoteltype
    obj.districts = hotel.district
    obj.company_id = hotel.try(:channel_manager).try(:company).try(:id)

    obj.build
  end

  def initialize
    @crawling_frequency = Setting::CRAWLING_FREQUENCIES.max
    @stars = [3, 4]
    @user_ratings = score_range(6.5)
    @property_types = Hotel::OLD_PROPERTY_TYPES.keys.first(3)
    @districts = []
  end

  def build
    {
      crawling_frequency: @crawling_frequency,
      stars: @stars.map(&:to_s),
      user_ratings: @user_ratings.map(&:to_s),
      property_types: @property_types,
      districts: @districts
    }
  end

  def score_range(score)
    to = score.to_f.ceil
    to = 1 if to.zero?

    from = to - 1

    (from*10..to*10).to_a.map { |n| n.to_f / 10 }
  end
end
