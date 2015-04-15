shared_examples_for HotelProperties do
  context 'with an instance' do
    context '#hoteltype' do
      it 'return string value for hoteltype_id' do
        hoteltype, id = described_class::OLD_PROPERTY_TYPES.to_a.sample
        hotel = Fabricate.build(:hotel, hoteltype_id: id)

        expect(hotel.hoteltype).to eq hoteltype
      end
    end
  end

  context 'scopes' do
    describe 'by_property_type' do
      let!(:scoped_hotel) { Fabricate.create(:hotel, hoteltype_id: 1) }
      let!(:other_hotel) { Fabricate.create(:hotel, hoteltype_id: 2) }

      it 'includes object only with desired property' do
        scoped = described_class.by_property_type(1)

        expect(scoped).to include(scoped_hotel)
        expect(scoped).not_to include(other_hotel)
      end
    end
  end

  context 'class methods' do
    before(:all) do
      described_class::BASE_FACILITIES.each_with_index do |name, i|
        Fabricate.create(:facility_hotel, name: name, id: i + 1)
      end
    end

    let!(:facility_hotel) { Fabricate.create(:facility_hotel) }

    context '.base_facilities' do
      it 'should contains only base facilities' do
        expect(described_class.base_facilities.map(&:name) - described_class::BASE_FACILITIES).to be_empty
      end
    end

    context '.base_facilities_cache' do
      it 'should get facilities from cache' do
        expect(described_class.base_facilities_cache).to eq(Rails.cache.read(Facility::Hotel::BASE_FACILITY_CACHE_KEY))
      end
    end
  end
end
