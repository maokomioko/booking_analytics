require 'spec_helper'

module Graph
  describe Data::Room, type: :model do
    before :all do
      @period = period = Date.today..5.days.from_now.to_date

      @rooms = Fabricate.times(3, :room) do
        room_prices do |attrs|
          period.map do |day|
            Fabricate(:room_price, date: day, room_id: attrs[:id])
          end
        end
      end

      @object = described_class.new(@rooms.map(&:id), @period)
    end

    describe '#initialize' do
      it 'assigns @rooms' do
        expect(@object.rooms.ids).to include(*@rooms.map(&:id))
      end

      it 'assigns @period' do
        expect(@object.period).to be_a_kind_of(Array)
      end

      it { expect(@object).to be_a_kind_of(Graph::Data) }
    end

    describe '#data' do
      it 'return array' do
        expect(@object.data).to be_kind_of(Array)
      end

      it 'contains parent data keys' do
        expect(@object.data.first.keys)
          .to include(*Data.new(@period).data.first.keys)
      end

      it 'contains keys for each room' do
        expect(@object.data.first.keys).to include(*@rooms.map(&:id))
      end
    end

    describe '#ykeys' do
      it 'contains all room ids' do
        expect(@object.ykeys).to include(*@rooms.map(&:id))
      end

      it 'contains parent ykeys first' do
        parent_ykeys = Data.new(@period).ykeys
        expect(@object.ykeys.slice(0, parent_ykeys.length))
          .to eq(parent_ykeys)
      end
    end

    describe '#labels' do
      it 'contains room names' do
        expect(@object.labels).to include(*@rooms.map(&:name))
      end
    end

    describe '#prices_by_date' do
      let(:described_hash) { @object.send(:prices_by_date) }

      it 'root keys contains all room ids' do
        expect(described_hash.keys).to match_array(@rooms.map(&:id))
      end

      it 'contains each date from period in room' do
        keys = described_hash[@rooms[0].id].keys

        expect(keys).to match_array(@object.period)
      end

      it 'contains float prices' do
        random_price = described_hash[@rooms[0].id].first.last
        expect(random_price).to be_a_kind_of(Float)
      end
    end
  end
end
