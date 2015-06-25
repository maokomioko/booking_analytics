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
      context 'old properties' do
        let!(:scoped_hoteltype) { described_class::OLD_PROPERTY_TYPES.first.first }
        let!(:scoped_hoteltype_id) { described_class::OLD_PROPERTY_TYPES.first.last }
        let!(:scoped_hotel) { Fabricate.create(:hotel, hoteltype_id: scoped_hoteltype_id) }

        let!(:other_hoteltype) { described_class::OLD_PROPERTY_TYPES.to_a.last.first }
        let!(:other_hoteltype_id) { described_class::OLD_PROPERTY_TYPES.to_a.last.last }
        let!(:other_hotel) { Fabricate.create(:hotel, hoteltype_id: other_hoteltype_id) }

        it 'includes object only with desired property' do
          scoped = described_class.by_property_type(scoped_hoteltype, 'old')

          expect(scoped).to include(scoped_hotel)
          expect(scoped).not_to include(other_hotel)
        end
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
