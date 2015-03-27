require 'rails_helper'

describe Hotel do
  it_behaves_like HotelProperties

  context 'association' do
    %i(location checkin checkout).each do |n|
      it { should have_one(n) }
    end

    it { should have_many(:rooms) }
    it { should have_one(:channel_manager).with_foreign_key(:booking_id) }

    %i(related facilities).each do |n|
      it { should have_and_belong_to_many(n) }
    end
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
  end
end
