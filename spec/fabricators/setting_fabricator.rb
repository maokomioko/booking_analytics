Fabricator(:setting) do
  crawling_frequency { Setting::CRAWLING_FREQUENCIES.sample }
  stars { %w(1 2 3 4 5).sample(rand(4)+1) }
  user_ratings { 5.times.map{ rand(0..100).to_f / 10 }.map(&:to_s) }
  property_types { Hotel::OLD_PROPERTY_TYPES.keys.sample(rand(3)+1) }
end