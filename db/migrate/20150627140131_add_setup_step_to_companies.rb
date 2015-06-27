class AddSetupStepToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :setup_step, :integer, :default => 1
    remove_column :users, :setup_completed, :boolean, default: false
  end
end
