class DropOptionalFromContacts < ActiveRecord::Migration
  def change
    remove_column :contacts, :optional
  end
end
