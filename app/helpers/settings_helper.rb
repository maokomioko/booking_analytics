module SettingsHelper
  def options_for_crawling_frequencies(default = nil)
    default ||= DefaultSetting.default[:crawling_frequency]
    options = Setting::CRAWLING_FREQUENCIES.map do |time|
      [humanize(time), time]
    end

    options_for_select(options, default)
  end

  def options_for_stars(default = nil)
    default ||= DefaultSetting.default[:stars]
    options = Setting::STARS.map do |n|
      ["#{n}*", n]
    end

    options_for_select(options, default)
  end

  def options_for_rating(default = nil)
    default ||= DefaultSetting.default[:user_ratings]
    options = Setting::USER_RATINGS

    options_for_select(options, default)
  end

  def options_for_properties(default = nil)
    default ||= DefaultSetting.default[:property_types]
    options = Hotel::OLD_PROPERTY_TYPES.map do |property, _id|
      [I18n.t("enum.property_type.#{property}"), property]
    end

    options_for_select(options, default)
  end

  def options_for_districts(default = nil, hotel = nil)
    city = hotel.present? ? hotel.city : 'Prague'
    default ||= DefaultSetting.for_hotel(hotel)[:districts] if hotel.present?

    options_for_select(Hotel.city_districts(city), default)
  end

  def options_for_booking_id(default, hotel_id)
    hotel = Hotel.find(hotel_id)
    room_ids = BlockAvailabilityExtractor.new(BlockAvailability.for_hotels(hotel.booking_id)).room_ids

    options_for_select(room_ids, default)
  end
end
