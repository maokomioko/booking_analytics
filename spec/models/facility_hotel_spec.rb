describe Facility::Hotel do
  describe 'callbacks' do
    describe 'clear_base_facility_cache' do
      let(:base_facility) { Fabricate.build(:base_facility_hotel) }
      let(:facility) { Fabricate.build(:facility_hotel) }

      it 'invokes after any commit' do
        expect(base_facility).to receive(:clear_base_facility_cache)
        base_facility.save
      end

      it 'do not invokes for non-base facility' do
        expect(facility).not_to receive(:clear_base_facility_cache)
        facility.save
      end

      it 'clear cache' do
        base_facility.save
        expect(Rails.cache.read(Facility::Hotel::BASE_FACILITY_CACHE_KEY)).to be_nil
      end
    end
  end
end
