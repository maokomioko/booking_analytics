Fabricator(:channel_manager) do
  type { "ChannelManager::Empty" }
  booking_id { Fabricate(:hotel).booking_id }
end
