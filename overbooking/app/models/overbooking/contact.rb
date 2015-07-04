module Overbooking
  class Contact < ActiveRecord::Base
    self.table_name = :contacts
    TYPES = %w(phone email skype viber whatsapp telegram other)

    belongs_to :hotel, class_name: 'Overbooking::Hotel'

    attr_accessor :contact_type

    validates_presence_of :value
    validates_inclusion_of :contact_type, in: TYPES, allow_blank: true

    def self.define_type(contact_type)
      if contact_type.present?
        'Overbooking::Contact::' + contact_type.classify
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
end
