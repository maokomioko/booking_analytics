namespace :hotels do
  desc "Fetch hotel websites"
  task fetch_hotel_urls: :environment do
    puts "Processing hotels"
    arr = []

    Hotel.all.limit(10).each do |hotel|
      g = GoogleCSE.search(hotel.name)
      begin
        url = g.fetch.results.map(&:link)
        puts url
        arr << g.fetch.results.map(&:link)
      rescue
      end
    end

    arr.flatten!
  end
end
