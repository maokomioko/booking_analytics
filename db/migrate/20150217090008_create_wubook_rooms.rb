class CreateWubookRooms < ActiveRecord::Migration
  def change
    create_table :wubook_rooms do |t|
      t.string :name
      t.integer :max_people

      t.integer :availability
      t.integer :occupancy

      t.integer :children

      t.belongs_to :wubook_auth
    end
  end
end
