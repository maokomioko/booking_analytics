class AddSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.float :amount
      t.string :currency
      t.integer :days

      t.string :state
      t.boolean :recurring

      t.integer :company_id

      t.timestamps
    end

    add_index :subscriptions, :state
    add_index :subscriptions, :recurring
    add_index :subscriptions, :company_id

    create_table :subscriptions_payment_items do |t|
      t.integer :subscription_id
      t.integer :payment_item_id
      t.float :cost
    end

    add_index :subscriptions_payment_items, :subscription_id
    add_index :subscriptions_payment_items, :payment_item_id

    create_table :payment_items do |t|
      t.string :name
    end
  end
end
