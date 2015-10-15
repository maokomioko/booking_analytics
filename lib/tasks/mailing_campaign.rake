desc 'generates mailing list for selected hotes'
task rates_campaign: :environment do
  value = ENV['ID'] || ENV['BOOKING_ID'] || ENV['NAME']
  field = if ENV['ID'].present?
            'id'
          elsif ENV['BOOKING_ID'].present?
            'booking_id'
          elsif ENV['NAME'].present?
            'name'
          end

  unless field.present? || value.present?
    puts "Wrong arguments. We expect hotel ID, BOOKING_ID or NAME"
    next
  end

  print "Looking for hotel(s)..."
  hotels = Hotel.where(field => value)

  if hotels.present?
    print "#{hotels.count} hotels found. Proceeding...\n".green
  else
    puts "No hotels found."
    next
  end

  hotels.each do |hotel|
    print "Updating related hotels for #{hotel.name}"
    if hotel.channel_managers.blank?
      hotel.channel_managers.build(connector_type: 'empty').save!
    end

    cm = hotel.channel_managers.first
    cm.sync_rooms

    # company = Company.new
    # company.channel_manager << cm

    # DefaultSetting.for_company(cm)

    hotel.amenities_calc
    puts hotel.related_ids
  end

  contacts = Contact.where(type: '', hotel_id: []).collect{||}
  unless contacts.blank?
  else
    puts "This hotel doesn't contain any email addresses."
  end
end

task overbooking_campaign: :environment do
end
