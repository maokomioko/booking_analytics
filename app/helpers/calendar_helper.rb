module CalendarHelper
  def calendar(date = Date.today, month_offset = 2, &block)
    Calendar.new(self, date, month_offset, block).week_rows
  end

  def set_day_class(date, price_block)
    klasses = []

    klasses << 'past' if date <= Date.today
    klasses << 'current_month' if date.month == Date.today.month
    klasses << 'next_month hidden' if date.month == Date.today.month + 1
    klasses << 'last_month hidden' if date.month == Date.today.month + 2
    klasses << 'active' if price_block.enabled && !price_block.locked

    klasses.join(' ').html_safe
  end

  def set_price(price)
    price = price.modulo(1) > 0 ? price : price.to_i
    price.to_s + ' €'
  rescue
    t('errors.price_value_missing')
  end

  def set_price_difference(price_block)
    klasses = []
    changed_value = price_block.default_price - price_block.price

    if price_block.default_price > price_block.price
      klasses << ['down_', 'fa-long-arrow-down']
    elsif price_block.default_price < price_block.price
      klasses << ['up_', 'fa-long-arrow-up']
    end

    return [klasses, changed_value.abs.to_s + ' EUR']
  end
end
