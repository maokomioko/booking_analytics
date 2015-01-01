class HotelWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, unique: true

  def perform(hotel)
    hotel.amenities_mix
  end
end
