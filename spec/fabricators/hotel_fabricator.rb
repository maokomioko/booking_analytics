Fabricator(:hotel) do
  name { FFaker::Company.name }
  city { FFaker::Address.city }
  city_id { rand(1000..5000) }
  address { FFaker::Address.street_address }
  district { FFaker::AddressNL.province }
  zip { FFaker::AddressNL.postal_code }
  url { FFaker::Internet.http_url }
  exact_class { rand(0..50) / 10 }
  review_score { rand(0..100) / 10 }
  booking_id { rand(1_000_000..2_000_000) }
  district { ['Praha 1', 'Praha 2', 'Praha 3', 'Praha 4'].sample(2) }
end

Fabricator(:hotel_without_address, class_name: :hotel) do
  name { FFaker::Company.name }
  url { FFaker::Internet.http_url }
  exact_class { rand(0..50) / 10 }
  review_score { rand(0..100) / 10 }
  booking_id { rand(1_000_000..2_000_000) }
end

Fabricator(:hotel_prague, class_name: :hotel) do
  name { FFaker::Company.name }
  city 'Prague'
  city_id '-553173'
  address { PRAGUE_ADDRESSES.sample[0] }
end
