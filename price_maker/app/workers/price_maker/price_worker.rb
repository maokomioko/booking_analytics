module PriceMaker
  class PriceWorker
    include Sidekiq::Worker

    sidekiq_options retry: false, unique: true, queue: 'alg'

    def expiration
      @expiration ||= 60 * 60 * 24 * 5 # 5 days
    end

    def perform(hotel_id, manual = false)
      hotel = Hotel.find(hotel_id)

      hotel.rooms.real.each do |room|
        room.fill_prices(hotel.channel_manager.company.settings.first.id) if room.roomtype?
      end

      unless manual
        time = hotel.channel_manager.company.settings.first.crawling_frequency rescue Setting.default_attributes[:crawling_requency]
        job_id = PriceMaker::PriceWorker.perform_in(time, hotel_id)
        hotel.update_column(:current_job, job_id)
      end
    end
  end
end
