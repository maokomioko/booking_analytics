module Overbooking
  class RelatedMarkerBuilder
    MARKERS = {
      default: { url: 'http://maps.gstatic.com/mapfiles/ridefinder-images/mm_20_gray.png', width: 12, height: 20 },
      partner: { url: 'http://maps.google.com/mapfiles/marker_green.png', width: 20, height: 34 }
    }

    def initialize(hotel_booking_id)
      @hotel = Overbooking::Hotel.find_by_booking_id(hotel_booking_id)
      @related = @hotel.related_hotels.includes(:related)
      @blocks = Overbooking::BlockExtractor.new(
          Overbooking::Block.for_hotels(@related.map{|r| r.related.booking_id})
            .today
      ).hotel_hash
    end

    def self.build(hotel_booking_id)
      new(hotel_booking_id).build
    end

    def build
      Gmaps4rails.build_markers(@related) do |hotel, marker|
        marker.lat hotel.related.latitude.to_f
        marker.lng hotel.related.longitude.to_f
        marker.picture marker_picture(hotel)
        marker.infowindow marker_infowindow(hotel)
      end
    end

    def marker_picture(hotel)
      if hotel.is_overbooking
        MARKERS[:partner]
      else
        MARKERS[:default]
      end
    end

    def marker_infowindow(hotel)
      ApplicationController.new.render_to_string(
          :partial => 'overbooking/directions/infowindow',
          :locals => {
            hotel: hotel.related,
            related: hotel,
            current_hotel: @hotel,
            block: @blocks[hotel.related.booking_id.to_s]
          }
      )
    end
  end
end
