class ModifySubscriptionPrices < ActiveRecord::Migration
  def change
    remove_column :subscriptions_payment_items, :cost
    add_column :payment_items, :price, :float
  end
end
