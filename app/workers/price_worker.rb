class PriceWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: false, unique: true

  #recurrence { hourly(1) }

  def perform
    rooms = WubookAuth.first.rooms
    unless rooms.nil?
      rooms.each do |room|
        room.fill_prices
      end
    end
  end
end
