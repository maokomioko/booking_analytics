class RemoveTimestampsFromBlocks < ActiveRecord::Migration
  def change
    [:active_block_availabilities, :archive_block_availabilities].each do |table|
      change_table table do |t|
        t.remove :created_at
        t.remove :updated_at
      end
    end
  end
end
