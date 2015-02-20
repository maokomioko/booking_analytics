class UniteRoomsWithWubookRooms < ActiveRecord::Migration
  def up
    add_column :rooms, :name, :string
    add_column :rooms, :availability, :integer
    add_column :rooms, :occupancy, :integer
    add_column :rooms, :children, :integer
    add_column :rooms, :wubook_auth_id, :integer
    add_column :rooms, :subroom, :integer
    add_column :rooms, :max_people, :integer
    add_column :rooms, :price, :float
    remove_column :rooms, :max_persons
    
    add_index :rooms, :wubook_auth_id

    drop_table :wubook_rooms
  end

  def down
    create_table :wubook_rooms do |t|
      t.string :name
      t.integer :max_people

      t.integer :availability
      t.integer :occupancy

      t.integer :children

      t.belongs_to :wubook_auth
    end

    remove_column :rooms, :name
    remove_column :rooms, :availability
    remove_column :rooms, :occupancy
    remove_column :rooms, :children
    remove_column :rooms, :wubook_auth_id
    remove_column :rooms, :subroom
    remove_column :rooms, :max_people
    remove_column :rooms, :price
    add_column :rooms, :max_persons, :string
  end
end
