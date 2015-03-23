Fabricator(:facility_hotel, from: 'Facility::Hotel') do
  id { rand(10_000..1_000_000) }
  name { FFaker::HipsterIpsum.word }
end

Fabricator(:base_facility_hotel, from: 'Facility::Hotel') do
  id { rand(10_000..1_000_000) }
  name { ParamSelectable::BASE_FACILITIES.sample }
end
