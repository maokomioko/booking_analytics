## USAGE
#  rake ID=1654 related_sender
#  rake BOOKING_ID=1146825
#  rake NAME=Orebitska
desc 'generates HTML document with related hotels for desired hotel'
task related_sender: :environment do
  value = ENV['ID'] || ENV['BOOKING_ID'] || ENV['NAME']
  field = if ENV['ID'].present?
            'id'
          elsif ENV['BOOKING_ID'].present?
            'booking_id'
          elsif ENV['NAME'].present?
            'name'
          end

  unless field.present? || value.present?
    puts "Wrong arguments. Use one of ID, BOOKING_ID, NAME"
    next
  end

  print "Search hotel... "
  hotel = Hotel.where(field => value).first

  if hotel.present?
    print "OK\n".green
  else
    puts "No hotel found."
    next
  end

  print "Build map info... "
  markers = MarkerBuilder.build(hotel.related.pluck(:booking_id)).to_json
  print "OK\n".green

  print "Render HTML file... "
  html = ApplicationController.new.render_to_string(
    layout: false,
    template: 'tasks/related_sender',
    locals: {
      :@hotel => hotel,
      :@markers => markers,
      :@related_hotels => hotel.related_hotels
    }
  )

  file = File.new Rails.root.join('tmp', ['related_sender-', SecureRandom.hex(5), '.html'].join), 'w+'
  file.write html
  file.close
  print "OK\n".green

  Launchy.open file.path
end
