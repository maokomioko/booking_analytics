class AddLastActivityToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :last_activity, :datetime
  end
end
