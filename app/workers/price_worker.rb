class PriceWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false, unique: true

  recurrence { hourly(1) }

  def perform
    WubookAuth.each do |auth|
      unless auth.rooms.nil?
        auth.rooms.each do |room|
          room.fill_prices
          #sleep 5
        end
      end
    end
  end
end
