object :@hotel

attributes :booking_id

node(:lat) { @hotel.latitude.to_f }
node(:lng) { @hotel.longitude.to_f }
node(:title) { @hotel.name }