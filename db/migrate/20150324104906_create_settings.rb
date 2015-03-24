class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :crawling_frequency
      t.text :stars, array: true, default: []
      t.text :user_ratings, array: true, default: []
      t.text :property_types, array: true, default: []

      t.belongs_to :company

      t.timestamps
    end

    add_index :settings, :company_id, unique: true
  end
end
