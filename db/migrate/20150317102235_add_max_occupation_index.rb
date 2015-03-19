Rails.application.config.active_record.schema_format = :sql

class AddMaxOccupationIndex < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION jsonb2arr(_j jsonb, _key text)
        RETURNS text[] LANGUAGE sql IMMUTABLE AS
      'SELECT ARRAY(SELECT elem->>_key FROM jsonb_array_elements(_j) elem)';
    SQL

    execute <<-SQL
      CREATE INDEX block_availabilities_max_occupancy_index ON block_availabilities
      USING gin (jsonb2arr((data->'block'), 'max_occupancy'));
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX block_availabilities_max_occupancy_index
    SQL
  end
end
