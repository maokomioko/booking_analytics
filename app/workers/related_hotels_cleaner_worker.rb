class RelatedHotelsCleanerWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(company_id, full_clean = false)
    company = Company.find(company_id)

    Hotel.where(booking_id: company.channel_manager.booking_id).each do |hotel|
      if full_clean
        hotel.related.clear
      else
        hotel.related.where(related_hotels: { is_overbooking: false, added_manually: false }).clear
      end
    end
  end
end
