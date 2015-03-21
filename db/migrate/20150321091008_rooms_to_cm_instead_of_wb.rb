class RoomsToCmInsteadOfWb < ActiveRecord::Migration
  def change
    rename_column :rooms, :wubook_auth_id, :channel_manager_id
  end
end
