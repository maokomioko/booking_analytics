class Contact::Phone < Contact
  phony_normalize :value
  validates_plausible_phone :value

  # this method needed for Phony validator
  def country_code
    Geocoder.search(hotel.city).first.country_code
  rescue Exception
    'CZ'
  end
end
