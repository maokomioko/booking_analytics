class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.string :name
      t.belongs_to :hotel

      t.timestamps
    end
  end
end
