class CreateChekins < ActiveRecord::Migration
  def change
    create_table :chekins do |t|
      t.string :to
      t.string :from
      t.belongs_to :hotel
    end

    add_index :chekins, :hotel_id
  end
end
