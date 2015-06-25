class RemoveMoneyGem < ActiveRecord::Migration
  def up
    remove_column :room_prices, :default_price_currency
    remove_column :room_prices, :price_currency
    rename_column :room_prices, :price_cents, :price
    execute 'ALTER TABLE room_prices ALTER COLUMN price TYPE double precision USING ((price::float/100)::double precision);'
    rename_column :room_prices, :default_price_cents, :default_price
    execute 'ALTER TABLE room_prices ALTER COLUMN default_price TYPE double precision USING ((default_price::float/100)::double precision);'

    remove_column :rooms, :max_price_currency
    remove_column :rooms, :min_price_currency
    rename_column :rooms, :max_price_cents, :max_price
    execute 'ALTER TABLE rooms ALTER COLUMN max_price TYPE double precision USING ((max_price::float)::double precision);'
    rename_column :rooms, :min_price_cents, :min_price
    execute 'ALTER TABLE rooms ALTER COLUMN min_price TYPE double precision USING ((min_price::float)::double precision);'
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover to Money gem"
  end
end
