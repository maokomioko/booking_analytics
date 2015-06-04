module Overbooking
  class DirectionsMailer < OverbookingMailer
    def notify_partner(hotel_booking_id, partner_booking_id, map_image)
      @hotel = Overbooking::Hotel.find_by_booking_id(hotel_booking_id)
      @partner = Overbooking::Hotel.find_by_booking_id(partner_booking_id)
      @map = map_image

      recievers = Overbooking::Company
                      .includes(:channel_manager, :owner)
                      .where(channel_managers: { booking_id: @partner.booking_id })
                      .map{ |c| c.owner.email }
                      .uniq

      if recievers.length > 0
        mail to: recievers, subject: I18n.t('overbooking.directions_mailer.notify_partner.subject', from: @hotel.name)
      end

      # for test
      # mail to: 'mikeeirih@me.com', subject: I18n.t('overbooking.directions_mailer.notify_partner.subject', from: @hotel.name)
    end
  end
end