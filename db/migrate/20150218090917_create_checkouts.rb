class CreateCheckouts < ActiveRecord::Migration
  def change
    create_table :checkouts do |t|
      t.string :from
      t.string :to
      t.belongs_to :hotel
    end

    add_index :checkouts, :hotel_id
  end
end
