class AddTransactionCodeToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :xmpay_answer, :string
  end
end
