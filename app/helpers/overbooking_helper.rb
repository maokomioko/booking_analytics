module OverbookingHelper
  def link_for_search_reservation(reservation)
    overbooking.search_reservations_path({
      price: reservation[:price],
      occupancy: reservation[:adults] + reservation[:children],
      arrival: reservation[:arrival],
      departure: reservation[:departure]
    })
  end

  def options_for_contact_types(default = nil)
    default ||= Contact::TYPES.first
    options = Contact::TYPES.map do |type|
      [I18n.t("enum.contact_type.#{ type }"), type]
    end

    options_for_select(options, default)
  end

  def contact_icon(type)
    case type
    when 'viber', 'telegram'
    'mobile-phone'
    else
      type
    end
  end

  def transit_icon(type)
    case type
    when 'walking'
      'male'
    when 'driving'
      'car'
    when 'transit'
      'bus'
    end
  end
end
