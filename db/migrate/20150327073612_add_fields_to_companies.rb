class AddFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :reg_number, :string
    add_column :companies, :reg_address, :string
  end
end
