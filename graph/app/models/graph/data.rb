module Graph
  class Data
    attr_accessor :period, :smooth, :post_units

    def self.format_period(period)
      unless period.is_a?(Array) || period.is_a?(Range)
        period = [period.to_date]
      end

      period.map do |day|
        day.strftime(self.date_format)
      end
    rescue ArgumentError, NoMethodError
      return []
    end

    def self.date_format
      '%Y-%m-%d'
    end

    def initialize(period)
      @period = self.class.format_period(period)
    end

    def xkeys
     [['x'] + @period]
    end

    def ykeys
      []
    end

    # for ykeys
    def labels
      []
    end

    def period= (period)
      @period = self.class.format_period(period)
    end
  end
end
