module CalendarHelper
  def calendar(date = Date.today, month_offset = 2, &block)
    Calendar.new(self, date, month_offset, block).week_rows
  end

  def set_price(price)
    price = price.modulo(1) > 0 ? price : price.to_i
    price.to_s + ' €'
  end
end
