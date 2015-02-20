class CreateRoomsWubookAuths < ActiveRecord::Migration
  def change
    create_table :rooms_wubook_auths do |t|
      t.references :room
      t.references :wubook_auth
    end

    add_index :rooms_wubook_auths, :wubook_auth_id
    add_index :rooms_wubook_auths, [:room_id, :wubook_auth_id], unique: true
  end
end
