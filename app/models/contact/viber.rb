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

class Contact::Viber < Contact
end
