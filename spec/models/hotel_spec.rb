require 'rails_helper'

describe Hotel do
  it_behaves_like HotelProperties

  context 'association' do
    %i(location checkin checkout).each do |n|
      it { should have_one(n) }
    end

    %i(rooms related_hotels related).each do |n|
      it { should have_many(n)}
    end

    it { should have_many(:channel_managers).with_foreign_key(:booking_id) }
    it { should have_and_belong_to_many(:facilities) }
  end

  context 'scopes' do
    describe 'facilities' do
      before(:all) do
        @facilities = Fabricate.times(2, :facility_hotel)

        @hotel_with_all_facilities = Fabricate.create(:hotel)
        @hotel_with_all_facilities.facilities << @facilities

        @hotel_with_one_facility = Fabricate.create(:hotel)
        @hotel_with_one_facility.facilities << @facilities.first
      end

      it 'includes contains facilities' do
        expect(described_class.contains_facilities(@facilities.map(&:id)))
          .to include(*[@hotel_with_all_facilities, @hotel_with_one_facility])
      end

      it 'includes strict with facilities' do
        scoped = described_class.with_facilities(@facilities.map(&:id))
        expect(scoped).to include(@hotel_with_all_facilities)
        expect(scoped).to_not include(@hotel_with_one_facility)
      end
    end

    describe 'with_stars' do
      before(:all) do
        @scoped = Fabricate.times(2, :hotel, exact_class: 3.1)
        @unscoped = Fabricate.times(2, :hotel, exact_class: rand(0..30) / 10)

        @collection = described_class.with_stars(3.1).map(&:id)
      end

      it 'includes with desired rate' do
        expect(@collection).to include(*@scoped.map(&:id))
      end

      it 'not includes other' do
        expect(@collection).to_not include(*@unscoped.map(&:id))
      end
    end

    describe 'with_score' do
      before(:all) do
        Fabricate.times(2, :hotel, review_score: rand(10..50) / 10)
        Fabricate.times(2, :hotel, review_score: rand(51..100) / 10)
      end

      describe 'gt' do
        it 'includes with greater score' do
          scores = described_class.with_score_gt(5.0).map(&:review_score)
          expect(scores.reject { |x| x > 5.0 }).to be_empty
        end
      end

      describe 'lt' do
        it 'includes with lighter score' do
          scores = described_class.with_score_lt(5.1).map(&:review_score)
          expect(scores.reject { |x| x < 5.1 }).to be_empty
        end
      end
    end

    describe 'with_district' do
      it 'includes any of searched district' do
        Fabricate.create(:hotel_without_address, district: 'd_1')
        Fabricate.create(:hotel_without_address, district: 'd_2')

        results = described_class.with_district('d_1').map do |hotel|
          hotel.district.include? 'd_1'
        end

        expect(results.reject{ |x| x }).to be_empty
      end
    end
  end

  describe '.city_districts' do
    before(:all) do
      Fabricate.create(:hotel_without_address,
                       city: 'Prague',
                       district: 'cd 2'
      )

      Fabricate.create(:hotel_without_address,
                       city: 'Prague',
                       district: 'cd 11'
      )

      Fabricate.create(:hotel_without_address,
                       city: 'Berlin',
                       district: 'cd fake'
      )

      @districts = described_class.city_districts('Prague')
    end

    it 'return uniq districts' do
      expect(@districts.uniq.length).to eq @districts.length
    end

    it 'return in naturally sort' do
      expect(@districts.index('cd 2')).to be < @districts.index('cd 11')
    end

    it 'return districts for searched town' do
      expect(@districts).to_not include('cd fake')
    end
  end

  describe '#full_address' do
    it 'return string' do
      expect(Fabricate.build(:hotel).full_address).to be_a_kind_of(String)
    end

    it 'rejects blank options' do
      hotel = Fabricate.build(:hotel_without_address, city: 'Test city')
      expect(hotel.full_address).to eq('Test city')
    end
  end
end
