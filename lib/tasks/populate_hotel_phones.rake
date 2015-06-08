namespace :hotels do
  desc "Fetch phone numbers from Google Places"
  task populate_phones: :environment do
    STDOUT.puts "Enter offset number"
    input = STDIN.gets.strip

    client = GooglePlaces::Client.new('AIzaSyAJxIYzlNIW9tIaFGL1lyRiNWpqrQ-l1F8')
    hotels = Hotel.all.offset(input).limit(100)

    hotels.each do |hotel|
      puts "#{hotel.name}"
      spots = client.spots(hotel.latitude, hotel.longitude, name: hotel.name)
      puts "#{spots.map(&:formatted_phone_number)}"
      #hotel.update_attribute(:phone, phone_number) unless phone_number.nil?
    end
  end
end
