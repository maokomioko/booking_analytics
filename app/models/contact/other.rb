class Contact::Other < Contact
  validates_presence_of :custom_type

  def contact_name
    custom_type
  end
end
