require 'spec_helper'

module Graph
  describe Data, type: :model do
    before :all do
      @period = Date.today..5.days.from_now.to_date
      @object = described_class.new(@period)
    end

    describe '.format_period' do
      it 'return array of converted dates' do
        period = [Date.new(1990, 1, 1), Date.new(1990, 1, 2)]
        format = described_class.format_period(period)

        expect(format).to match_array(%w(01.01.1990 02.01.1990))
      end

      it 'can processing with string' do
        format = described_class.format_period('1990-01-01')
        expect(format).to match_array(%w(01.01.1990))
      end

      it 'raise on wrong date argument' do
        format_string = described_class.format_period('privet')
        format_fixnum = described_class.format_period(5)

        expect(format_string).to eq []
        expect(format_fixnum).to eq []
      end
    end

    describe '#initialize' do
      it 'assigns @period' do
        expect(@object.period).to be_a(Array)
      end
    end

    describe '#data' do
      it 'return array' do
        expect(@object.data).to be_a(Array)
      end

      context 'element of array' do
        it 'contains xkey key' do
          expect(@object.data.first).to have_key(@object.xkey.to_sym)
        end
      end
    end

    describe '#xkey' do
      it 'return string' do
        expect(@object.xkey).to be_a(String)
      end
    end

    describe '#ykeys' do
      it 'return array' do
        expect(@object.ykeys).to be_a(Array)
      end
    end

    describe '#labels' do
      it 'return array' do
        expect(@object.labels).to be_a(Array)
      end
    end

    describe '#period=' do
      it 'set formatted values' do
        @object.period = [Date.new(1990, 1, 1), Date.new(1990, 1, 2)]
        expect(@object.period).to match_array(%w(01.01.1990 02.01.1990))
      end
    end
  end
end