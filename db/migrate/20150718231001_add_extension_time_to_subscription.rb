class AddExtensionTimeToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :extended_at, :datetime
  end
end
