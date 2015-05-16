Fabricator(:source, class_name: 'Graph::Source') do
  booking_id { Fabricate(:hotel).booking_id }
  data { |attrs| DataBuilder.build({ booking_id: attrs[:booking_id] }) }
  max_occupancy do |attrs|
    attrs[:data][:block].map do |block|
      block[:max_occupancy]
    end.uniq
  end
end
