class RemoveWubookAuths < ActiveRecord::Migration
  def change
    drop_table :rooms_wubook_auths
  end
end
