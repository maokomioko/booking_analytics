# == Schema Information
#
# Table name: contacts
#
#  id          :integer          not null, primary key
#  type        :string
#  custom_type :string
#  value       :string
#  description :string
#  preferred   :boolean          default(FALSE)
#  hotel_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_contacts_on_type  (type)
#

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
