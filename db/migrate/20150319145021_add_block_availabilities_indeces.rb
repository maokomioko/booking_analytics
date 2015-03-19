Rails.application.config.active_record.schema_format = :sql

class AddBlockAvailabilitiesIndeces < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute("
      CREATE INDEX active_block_availabilities_hotel_id_index ON active_block_availabilities ( ((data->>'hotel_id')::integer) );
      CREATE INDEX active_block_availabilities_arrival_date_index ON active_block_availabilities ( ((data->>'arrival_date')) );
      CREATE INDEX active_block_availabilities_departure_date_index ON active_block_availabilities ( ((data->>'departure_date')) );

      CREATE INDEX archive_block_availabilities_hotel_id_index ON archive_block_availabilities ( ((data->>'hotel_id')::integer) );
      CREATE INDEX archive_block_availabilities_arrival_date_index ON archive_block_availabilities ( ((data->>'arrival_date')) );
      CREATE INDEX archive_block_availabilities_departure_date_index ON archive_block_availabilities ( ((data->>'departure_date')) );
    ")
  end

  def down
    execute <<-SQL
      DROP INDEX active_block_availabilities_hotel_id_index;
      DROP INDEX active_block_availabilities_arrival_date_index;
      DROP INDEX active_block_availabilities_departure_date_index;

      DROP INDEX archive_block_availabilities_hotel_id_index;
      DROP INDEX archive_block_availabilities_arrival_date_index;
      DROP INDEX archive_block_availabilities_departure_date_index;
    SQL
  end
end
