class RelatedHotelsCleanerWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(company_id)
    company = Company.find(company_id)

    Hotel.where(booking_id: company.channel_managers.pluck(:booking_id)).each do |hotel|
      hotel.related.clear
    end
  end
end
