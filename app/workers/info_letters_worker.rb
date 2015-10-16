class InfoLettersWorker
  include Sidekiq::Worker

  sidekiq_options retry: true

  def perform(booking_ids)
    begin
      hotels = Hotel.joins(:contacts).where(booking_id: booking_ids)
      hotels.each do |hotel|
        email_contacts = hotel.contacts.where(type: 'Contact::Email')
        unless email_contacts.nil?
          prepare_hotels(hotel)

          hotel.related.each do |related_hotel|
            prepare_hotels(related_hotel)
          end

          MarketingMailer.delay.hc_curiosity(hotel, email_contacts.map(&:value))
        else
          print "These hotels don't have email addresses"
        end
      end
    rescue
      Rails.logger.warn "Hotels or emails not found. IDS #{booking_ids}"
    end
  end

  private

  def prepare_hotels(hotel)
    if hotel.channel_managers.blank?
      hotel.channel_managers.build(type: 'ChannelManager::Empty').save!
    end
    cm = hotel.channel_managers.first
    cm.sync_rooms
    hotel.amenities_calc
  end
end
