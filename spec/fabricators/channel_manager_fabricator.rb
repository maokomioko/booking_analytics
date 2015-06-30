Fabricator(:channel_manager) do
  type { "ChannelManager::Empty" }
  hotel_name { '111' }
  booking_id { Fabricate(:hotel).booking_id }
end
