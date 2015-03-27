class SegregateBlockAvailabilities < ActiveRecord::Migration
  def change
    drop_table :block_availability if ActiveRecord::Base.connection.table_exists? 'block_availability'
    rename_table :block_availabilities, :active_block_availabilities

    ActiveRecord::Base.connection.execute('CREATE TABLE archive_block_availabilities AS SELECT * FROM active_block_availabilities;')
  end
end
