class CreateIncrementalPrices < ActiveRecord::Migration
  def change
    create_table :incremental_prices do |t|
      t.string :currency
      t.float :price

      t.belongs_to :block
    end

    add_index :incremental_prices, :block_id
  end
end
