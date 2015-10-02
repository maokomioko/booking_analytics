class MarkerBuilder
  MARKERS = {
    default: { url: 'http://maps.gstatic.com/mapfiles/ridefinder-images/mm_20_gray.png', width: 12, height: 20 },
    partner: { url: 'http://maps.google.com/mapfiles/marker_green.png', width: 20, height: 34 }
  }

  def initialize(hotel_booking_ids, current_booking_id = nil)
    @hotels = Hotel.where('booking_id IN (?)', hotel_booking_ids.split(','))

    if current_booking_id.present?
      @hotel = Hotel.find_by_booking_id(current_booking_id)
      @partners = @hotel
                      .related_hotels.where(is_overbooking: true)
                      .pluck(:related_id) & @hotels.pluck(:id)
    else
      @partners = []
    end

    @blocks = BlockAvailabilityExtractor.new(
      BlockAvailability.for_hotels(@hotels.map(&:booking_id)).today
    ).hotel_hash
  end

  def self.build(hotel_booking_ids, current_booking_id)
    new(hotel_booking_ids, current_booking_id).build
  end

  def build
    Gmaps4rails.build_markers(@hotels) do |hotel, marker|
      marker.lat hotel.latitude.to_f
      marker.lng hotel.longitude.to_f
      marker.picture marker_picture(hotel)
      marker.infowindow marker_infowindow(hotel)
      marker.json(booking_id: hotel.booking_id)
    end
  end

  def marker_picture(hotel)
    if @partners.include?(hotel.id)
      MARKERS[:partner]
    else
      MARKERS[:default]
    end
  end

  def marker_infowindow(hotel)
    ApplicationController.new.render_to_string(
        partial: 'hotels/infowindow',
        locals: {
          hotel: hotel,
          partner: @partners.include?(hotel.id),
          current_hotel: @hotel,
          block: @blocks[hotel.booking_id.to_s]
        }
    )
  end
end
