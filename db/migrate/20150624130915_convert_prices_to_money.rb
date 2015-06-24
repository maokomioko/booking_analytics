class ConvertPricesToMoney < ActiveRecord::Migration
  def up
    execute('UPDATE rooms SET min_price_cents = min_price_cents * 100, max_price_cents = max_price_cents * 100 WHERE min_price_cents < 2000 OR max_price_cents < 3500')
  end

  def down
    execute('UPDATE rooms SET min_price_cents = min_price_cents / 100, max_price_cents = max_price_cents / 100')
  end
end
