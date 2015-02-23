class MoveToMoney < ActiveRecord::Migration
  def up
    # IncrementalPrice
    execute %q{ALTER TABLE incremental_prices ALTER COLUMN price TYPE integer USING ((price*100)::integer);}
    rename_column :incremental_prices, :price, :price_cents
    rename_column :incremental_prices, :currency, :price_currency
    change_column_default :incremental_prices, :price_currency, Money.default_currency.to_s

    # RoomPrice
    execute %q{ALTER TABLE room_prices ALTER COLUMN price TYPE integer USING ((price*100)::integer);}
    rename_column :room_prices, :price, :price_cents
    add_column :room_prices, :price_currency, :string, default: Money.default_currency.to_s
    execute %q{ALTER TABLE room_prices ALTER COLUMN default_price TYPE integer USING ((default_price*100)::integer);}
    rename_column :room_prices, :default_price, :default_price_cents
    add_column :room_prices, :default_price_currency, :string, default: Money.default_currency.to_s

    # Room
    execute %q{ALTER TABLE rooms ALTER COLUMN min_price TYPE integer USING ((min_price*100)::integer);}
    rename_column :rooms, :min_price, :min_price_cents
    add_column :rooms, :min_price_currency, :string, default: Money.default_currency.to_s
    execute %q{ALTER TABLE rooms ALTER COLUMN max_price TYPE integer USING ((max_price*100)::integer);}
    rename_column :rooms, :max_price, :max_price_cents
    add_column :rooms, :max_price_currency, :string, default: Money.default_currency.to_s
  end

  def down
    change_column_default :incremental_prices, :price_currency, nil
    rename_column :incremental_prices, :price_currency, :currency
    rename_column :incremental_prices, :price_cents, :price
    execute %q{ALTER TABLE incremental_prices ALTER COLUMN price TYPE double precision USING ((price::float/100)::double precision);}

    remove_column :room_prices, :default_price_currency
    remove_column :room_prices, :price_currency
    rename_column :room_prices, :price_cents, :price
    execute %q{ALTER TABLE room_prices ALTER COLUMN price TYPE double precision USING ((price::float/100)::double precision);}
    rename_column :room_prices, :default_price_cents, :default_price
    execute %q{ALTER TABLE room_prices ALTER COLUMN default_price TYPE double precision USING ((default_price::float/100)::double precision);}

    remove_column :rooms, :max_price_currency
    remove_column :rooms, :min_price_currency
    rename_column :rooms, :max_price_cents, :max_price
    execute %q{ALTER TABLE rooms ALTER COLUMN max_price TYPE double precision USING ((max_price::float/100)::double precision);}
    rename_column :rooms, :min_price_cents, :min_price
    execute %q{ALTER TABLE rooms ALTER COLUMN min_price TYPE double precision USING ((min_price::float/100)::double precision);}
  end
end
