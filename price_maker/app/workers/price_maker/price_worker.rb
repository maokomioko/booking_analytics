module PriceMaker
  class PriceWorker
    include Sidekiq::Worker

    sidekiq_options retry: false, unique: true, queue: 'alg'

    def expiration
      @expiration ||= 60*60*24*5 # 5 days
    end

    def perform(hotel_id)
      hotel = Hotel.find(hotel_id)

      hotel.rooms.real.each do |room|
        room.fill_prices
      end

      job_id = PriceMaker::PriceWorker.perform_in(hotel.channel_manager.company.setting.crawling_frequency, hotel_id)
      hotel.update_column(:current_job, job_id)
    end
  end
end
