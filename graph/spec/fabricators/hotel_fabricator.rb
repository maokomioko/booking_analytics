Fabricator(:hotel) do
  name { FFaker::Company.name }
  exact_class { rand(0..50) / 10 }
  review_score { rand(0..100) / 10 }
  booking_id { rand(1_000_000..2_000_000) }
end
