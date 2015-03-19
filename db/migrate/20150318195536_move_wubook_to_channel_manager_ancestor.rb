class MoveWubookToChannelManagerAncestor < ActiveRecord::Migration
  def change
    rename_table :wubook_auths, :channel_managers
    add_column :channel_managers, :type, :string

    execute("UPDATE channel_managers SET type = 'wubook'")

    change_column :channel_managers, :type, :string, null: false
  end
end
