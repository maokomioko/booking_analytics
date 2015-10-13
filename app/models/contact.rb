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

  def self.define_type(contact_type)
    if contact_type.present?
      'Contact::' + contact_type.classify
    else
      self.name
    end
  end

  def contact_type
    if type.nil?
      @contact_type
    else
      @contact_type || self.class.name.split('::').last.downcase
    end
  end

  def contact_name
    contact_type
  end
end
