class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.boolean :wb_auth, default: false
      t.integer :owner_id

      t.timestamps
    end

    add_column :users, :company_id, :integer
    add_index :users, :company_id
    remove_column :users, :wb_auth, :boolean, default: false

    remove_column :wubook_auths, :user_id, :integer
    add_column :wubook_auths, :company_id, :integer
    add_index :wubook_auths, :company_id
  end
end
