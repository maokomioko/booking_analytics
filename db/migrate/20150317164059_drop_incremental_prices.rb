class DropIncrementalPrices < ActiveRecord::Migration
  def change
    drop_table :incremental_prices do |t|
      t.string :currency
      t.float :price

      t.belongs_to :block
    end
  end
end
