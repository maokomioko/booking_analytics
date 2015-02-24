class AddFieldsToBlocks < ActiveRecord::Migration
  def change
    add_column :block_availabilities, :booking_id, :integer
    add_column :block_availabilities, :created_at, :datetime
    add_column :block_availabilities, :updated_at, :datetime

    add_index :block_availabilities, :booking_id

    add_column :blocks, :block_id, :string, limit: 40
    add_column :blocks, :refundable, :boolean
    add_column :blocks, :refundable_until, :string
    add_column :blocks, :deposit_required, :boolean
    add_column :blocks, :breakfast_included, :boolean
    add_column :blocks, :created_at, :datetime
    add_column :blocks, :updated_at, :datetime

    add_index :blocks, :block_id
  end
end
