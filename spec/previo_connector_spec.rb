require 'rails_helper'
require 'previo_connector'

describe PrevioConnector do
  let(:connector) do
    described_class.new(
        login: 'login',
        password: 'password',
        hotel_id: 666
    )
  end

  describe 'get_rooms' do
    it 'fetches room list' do
      VCR.use_cassette('get_rooms', record: :once) do
        results = connector.get_rooms
        expect(results['roomKinds']['objectKind'].count).to be > 0
      end
    end
  end

  describe 'get_plans' do
    before(:each){ VCR.insert_cassette('get_plans') }
    after(:each){ VCR.eject_cassette }

    it 'return plans valid for today' do
      Timecop.freeze(Date.new(2015, 5, 15)) do
        expect(connector.get_plans.count).to eq 1
      end
    end

    it 'raises if no plans for today' do
      Timecop.freeze(Date.new(2010, 1, 1)) do
        expect { connector.get_plans }.
          to raise_error PrevioConnector::PrevioError
      end
    end
  end
end

describe PrevioConnector::Client do
  it 'include httparty methods' do
    expect(described_class).to include HTTParty
  end

  it 'have the base url set to the Previo API endpoint' do
    expect(described_class.base_uri).to eq 'https://api.previo.cz'
  end
end

describe PrevioConnector::Previo do
  let(:client) { described_class.new('login', 'password') }

  it { expect(client).to be_kind_of PrevioConnector::Client }

  describe 'post' do
    it 'raises API error for bad request' do
      VCR.use_cassette('previo_api_error', record: :once) do
        expect { client.post('Some.undefinedMethod') }
          .to raise_error PrevioConnector::PrevioAPIError
      end
    end
  end

  describe 'get_rates' do
    it 'returns array' do
      VCR.use_cassette('get_plans', record: :once) do
        expect(client.get_rates({ 'hotId' => 666 })).to be_a(Array)
      end
    end
  end
end

describe PrevioConnector::AR do
  it { expect(described_class.new).to be_kind_of PrevioConnector::Client }
end

describe PrevioConnector::BC do
  it { expect(described_class.new).to be_kind_of PrevioConnector::Client }
end

describe PrevioConnector::BR do
  it { expect(described_class.new).to be_kind_of PrevioConnector::Client }
end
