module CalendarHelper
  def calendar(date = Date.today, month_offset = 2, &block)
    Calendar.new(self, date, month_offset, block).week_rows
  end

  def set_day_class(price_block)
    klasses = []

    klasses << 'with_applied_price' if price_block.enabled
    klasses << 'with_lock' if price_block.locked

    return klasses.join(' ').html_safe
  end

  def set_price(price)
    begin
      price = price.modulo(1) > 0 ? price : price.to_i
      price.to_s + ' €'
    rescue
      t('errors.price_value_missing')
    end
  end
end
