class AddFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :logo, :string
    add_column :companies, :reg_number, :string
    add_column :companies, :reg_address, :string
    add_column :companies, :bank_name, :string
    add_column :companies, :bank_code, :string
    add_column :companies, :bank_account, :string
  end
end
