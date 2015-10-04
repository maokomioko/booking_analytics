class ActiveCompaniesWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform
    Company.where("last_activity > current_timestamp - interval '30 minutes'").find_each do |company|
      next unless company.setup_completed?
      DefaultRoomPriceSyncWorker.perform_async(company.channel_manager.id)
    end
  end
end

#
# Fetch room's default prices from connector
#
class DefaultRoomPriceSyncWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, queue: :active,
                  unique: :all, expiration: 10.minutes

  def perform(channel_manager_id)
    channel_manager = ChannelManager.find(channel_manager_id)
    channel_manager.sync_rooms
  end
end
