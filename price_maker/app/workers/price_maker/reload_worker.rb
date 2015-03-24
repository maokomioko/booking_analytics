module PriceMaker
  class ReloadWorker
    include Sidekiq::Worker

    sidekiq_options retry: false, unique: true

    def perform(company_id)
      company = Company.find(company_id)

      Hotel.where(booking_id: company.channel_managers.pluck(:booking_id)).each do |hotel|
        next if hotel.current_job? && Sidekiq::Status::working?(hotel.current_job)

        if Sidekiq::Status::queued?(hotel.current_job)
          Sidekiq::Status.unschedule hotel.current_job
        end

        job_id = PriceMaker::PriceWorker.perform_in(company.setting.crawling_frequency, hotel.id)
        hotel.update_column(:current_job, job_id)
      end
    end
  end
end
