{
    id: @hotel.booking_id,
    text: [@hotel.name, @hotel.address, @hotel.booking_id].join(' / ')
}.to_json