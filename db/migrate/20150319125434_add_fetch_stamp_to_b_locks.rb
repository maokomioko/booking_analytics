class AddFetchStampToBLocks < ActiveRecord::Migration
  def change
    add_column :active_block_availabilities, :fetch_stamp, :integer
    add_column :archive_block_availabilities, :fetch_stamp, :integer
  end
end
