Fabricator(:hotel) do
  name { FFaker::Company.name }
  city { FFaker::Address.city }
  city_id { rand(1000..5000) }
  address { FFaker::Address.street_address }
  district { FFaker::AddressNL.province }
  zip { FFaker::AddressNL.postal_code }
  url { FFaker::Internet.http_url }
  exact_class { Setting::STARS.sample }
  review_score { Setting::USER_RATINGS.sample }
  booking_id { rand(1_000_000..2_000_000) }
end

Fabricator(:hotel_without_address, class_name: :hotel) do
  name { FFaker::Company.name }
  url { FFaker::Internet.http_url }
  exact_class { Setting::STARS.sample }
  review_score { Setting::USER_RATINGS.sample }
  booking_id { rand(1_000_000..2_000_000) }
end

Fabricator(:hotel_prague, class_name: :hotel) do
  name { FFaker::Company.name }
  city 'Prague'
  city_id '-553173'
  address { PRAGUE_ADDRESSES.sample[0] }
  exact_class { Setting::STARS.sample }
  review_score { Setting::USER_RATINGS.sample }
end
