module Overbooking
  module ContactsHelper
    def options_for_contact_types(default = nil)
      default ||= Overbooking::Contact::TYPES.first
      options = Overbooking::Contact::TYPES.map do |type|
        [I18n.t("overbooking.enum.contact_type.#{ type }"), type]
      end

      options_for_select(options, default)
    end
  end
end
