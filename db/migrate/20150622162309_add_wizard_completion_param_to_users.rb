class AddWizardCompletionParamToUsers < ActiveRecord::Migration
  def change
    add_column :users, :setup_completed, :boolean, default: false
  end
end
