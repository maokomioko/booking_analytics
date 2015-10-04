ActionDispatch::Reloader.to_prepare do
  if (Room.connection rescue nil)
    Room.send(:include, PriceMaker::ChannelManager)
  end

  if (Hotel.connection rescue nil)
    Hotel.send(:include, PriceMaker::HotelAmenities)
  end
end
