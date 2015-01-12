module CalendarHelper
  def calendar(date = Date.today, &block)
    Calendar.new(self, date, block).week_rows
  end
end
