Rails.application.config.active_record.schema_format = :sql

class AddGinIndexForBlockAvailabilitiesBlocks < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX active_block_availabilities_blocks_gin_idx ON active_block_availabilities
        USING gin ((data->'block') jsonb_path_ops);
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX active_block_availabilities_blocks_gin_idx
    SQL
  end
end
