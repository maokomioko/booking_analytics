require 'spec_helper'

module Graph
  describe Source, type: :model do
    describe 'database source' do
      it 'table name should be get from gem config' do
        expect(described_class.table_name).to eq Graph.source_table.to_s
      end

      it 'contains required fields' do
        expect(described_class.column_names).
            to include(*%w(id data booking_id max_occupancy))
      end
    end

    describe 'scopes' do
      before(:all) do
        @hotels = Fabricate.times(3, :hotel) do
          sources do |attrs|
            2.times.map do
              Fabricate(:source, booking_id: attrs[:booking_id])
            end
          end
        end
      end

      context '.for_hotels' do
        it 'return only required' do
          hotel_ids = @hotels.map(&:booking_id).first(2)
          result = described_class.for_hotels(hotel_ids).pluck(:booking_id).uniq
          expect(result.sort).to eq hotel_ids.sort
        end
      end

      context '.by_arrival' do
        it 'returns with selected arrival date' do
          result = described_class.by_arrival(Date.today).map do |source|
            source.data['arrival_date']
          end.uniq

          expect(result.length).to eq 1
          expect(result[0].to_date).to eq Date.today
        end
      end

      context '.by_departure' do
        it 'returns with selected departure date' do
          result = described_class.by_departure(Date.tomorrow).map do |source|
            source.data['departure_date']
          end.uniq

          expect(result.length).to eq 1
          expect(result[0].to_date).to eq Date.tomorrow
        end
      end
    end
  end
end
