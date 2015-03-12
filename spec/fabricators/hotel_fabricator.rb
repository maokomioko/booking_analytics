Fabricator(:hotel) do
  name { Faker::Company.name }
  city { Faker::Address.city }
  city_id { rand(1000..5000) }
  address { Faker::Address.street_address }
  district { Faker::AddressNL.province }
  zip { Faker::AddressNL.postal_code }
  url { Faker::Internet.http_url }
  exact_class { rand(0..50) / 10 }
  review_score { rand(0..100) / 10 }
  booking_id { rand(1000000..2000000) }
end
