{
  lat: @hotel.latitude.to_f,
  lng: @hotel.longitude.to_f,
  id: @hotel.booking_id,
  title: @hotel.name,
  markers_path: markers_direction_path(id: @hotel.booking_id)
}.to_json