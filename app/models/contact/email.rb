class Contact::Email < Contact
  validates_format_of :value, with: Devise::email_regexp
end
