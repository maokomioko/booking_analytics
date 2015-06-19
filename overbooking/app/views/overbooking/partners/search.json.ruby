@hotels.map do |hotel|
  {
    id: hotel.booking_id,
    text: [hotel.name, hotel.address, hotel.booking_id].join(' / ')
  }
end.to_json