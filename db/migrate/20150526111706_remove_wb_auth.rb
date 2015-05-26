class RemoveWbAuth < ActiveRecord::Migration
  def change
    remove_column :companies, :wb_auth
  end
end
