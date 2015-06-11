module Overbooking
  module ReservationsHelper
    def link_for_search_reservation(reservation)
      overbooking.search_reservations_path({
        price: reservation[:price].cents,
        occupancy: reservation[:adults] + reservation[:children],
        arrival: reservation[:arrival],
        departure: reservation[:departure]
      })
    end
  end
end
