module SettingsHelper
  def options_for_crawling_frequencies(default = nil)
    default ||= Setting.default_attributes[:crawling_frequency]
    options = Setting::CRAWLING_FREQUENCIES.map do |time|
      [ humanize(time), time ]
    end

    options_for_select(options, default)
  end

  def options_for_stars(default = nil)
    default ||= Setting.default_attributes[:stars]
    options = Setting::STARS.map do |n|
      [ "#{n}*", n ]
    end

    options_for_select(options, default)
  end

  def options_for_rating(default = nil)
    default ||= Setting.default_attributes[:user_ratings]
    options = Setting::USER_RATINGS

    options_for_select(options, default)
  end

  def options_for_properties(default = nil)
    default ||= Setting.default_attributes[:property_types]
    options = Hotel::OLD_PROPERTY_TYPES.map do |property, id|
      [I18n.t("enum.property_type.#{property}"), property]
    end

    options_for_select(options, default)
  end
end