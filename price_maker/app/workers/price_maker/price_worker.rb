module PriceMaker
  class PriceWorker
    include Sidekiq::Worker

    sidekiq_options retry: false, unique: true, queue: 'alg'

    def expiration
      @expiration ||= 60 * 60 * 24 * 5 # 5 days
    end

    def perform(setting_id)
      setting = ::Setting.find(setting_id)
      hotel = setting.hotel

      # prevent queue stacking of workers
      # for example: user submit 5 times settings form
      return true if setting.sidekiq_lock

      if setting.current_job?
        # wait while old task complete
        if Sidekiq::Status.working?(setting.current_job)
          setting.lock!

          begin
            sleep(10)

            if Sidekiq::Status.working?(setting.current_job)
              puts 'Currently in progress...'
              raise 'Currently in progress'
            end
          rescue Exception
            retry
          end
        # unschedule current planning job
        elsif Sidekiq::Status.queued?(setting.current_job)
          setting.lock!
          Sidekiq::Status.unschedule setting.current_job
        end
      end

      hotel.rooms.real.each do |room|
        room.fill_prices(setting.id) if room.roomtype?
      end

      reload(setting.id)
    end

    def reload(setting_id)
      setting = ::Setting.find(setting_id)

      time = setting.crawling_frequency rescue Setting.default_attributes[:crawling_requency]
      job_id = PriceMaker::PriceWorker.perform_in(time, setting.id)
      setting.update_column(:current_job, job_id)

      setting.unlock!
    end
  end
end
