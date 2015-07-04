class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :type
      t.string :custom_type
      t.string :value
      t.string :optional
      t.string :description
      t.boolean :preferred, default: false

      t.belongs_to :hotel

      t.timestamps
    end

    add_index :contacts, :type
  end
end
