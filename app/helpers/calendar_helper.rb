module CalendarHelper
  def calendar(date, prices, month_offset = 3, &block)
    Calendar.new(self, date, month_offset, block, prices).output
  end

  def display_month(date)
    Date::MONTHNAMES[date.month]
  end

  def set_price(price)
    price = price.modulo(1) > 0 ? price : price.to_i
    number_to_euro(price.to_s)
  rescue
    t('errors.price_value_missing')
  end

  def set_price_class(price_block)
    klass = price_block.price.to_i < price_block.default_price ? 'decreased' : 'increased'
    klass.html_safe
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
