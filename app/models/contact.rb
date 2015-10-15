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

class Contact < ActiveRecord::Base
  TYPES = %w(phone email skype viber whatsapp telegram other)

  belongs_to :hotel

  attr_accessor :contact_type

  validates_presence_of :value
  validates_inclusion_of :contact_type, in: TYPES, allow_blank: true

  rails_admin do
    navigation_label 'Hotels'
    list do
      field :id
      field :hotel
      field :contact_type
      field :value
      field :description
    end
  end

  def contact_name
    contact_type
  end

  def contact_type
    value = if type.nil?
      @contact_type
    else
      @contact_type || self.class.name.split('::').last.downcase
    end

    value
  end

  def self.define_type(contact_type = nil)
    !contact_type.nil? ? 'Contact::' + contact_type.classify : 'Contact::Other'
  end
end
