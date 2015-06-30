require 'rails_helper'

describe DefaultSetting do
  let(:default_setting) { described_class.new }

  describe '#default' do
    it 'shortcut for `default` instance method' do
      expect(described_class.default).to eq default_setting.build
    end
  end

  describe '#for_company' do
    let(:cm) do
      cm = Fabricate(:channel_manager) do
        company { Fabricate(:company) }
      end
    end
    let(:company) { cm.company }
    let(:hotel) { cm.hotel }
    let(:hash) { described_class.for_company(company) }

    it 'uses values from hotel object' do
      expect(hash[:stars]).to eq [hotel.exact_class.to_i.to_s]
      expect(hash[:user_ratings]).to include(hotel.review_score.to_s)
      if hotel.hoteltype
        expect(hash[:property_types]).to include(hotel.hoteltype)
      end
      expect(hash[:districts]).to eq hotel.district
    end
  end

  describe '.build' do
    let(:hash) { default_setting.build }

    it 'contains required keys' do
      expect(hash).to include(:crawling_frequency, :stars, :user_ratings,
                              :property_types, :districts)
    end

    it 'stars values are string' do
      types = hash[:stars].map{ |h| h.class.name }.uniq
      expect(types.length).to eq 1
      expect(types.first).to eq 'String'
    end

    it 'user_ratings values are string' do
      types = hash[:user_ratings].map{ |h| h.class.name }.uniq
      expect(types.length).to eq 1
      expect(types.first).to eq 'String'
    end
  end

  describe '.score_range' do
    let(:string_score) { '6.2' }
    let(:score) { 6.2 }
    let(:zero_score) { 0 }

    it 'converts String to Float' do
      expect(default_setting.score_range(string_score)).
          to include(6.5)
    end

    it 'contains 11 values' do
      expect(default_setting.score_range(score).length).to eq 11
    end

    it 'count range from 0 to 1 if zero score given' do
      expect(default_setting.score_range(zero_score)).
        to include(0.0, 1.0, 0.5)
    end

    it 'contains values from 6 to 7 with 0.1 step' do
      scores = [6.0, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 6.8, 6.9, 7.0]
      expect(default_setting.score_range(score)).to include(*scores)
    end
  end
end
