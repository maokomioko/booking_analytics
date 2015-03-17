Rails.application.config.active_record.schema_format = :sql

class AddBlockAvailabilitiesIndeces < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX block_availabilities_hotel_id_index ON block_availabilities ( ((data->>'hotel_id')::integer) );
      CREATE INDEX block_availabilities_arrival_date_index ON block_availabilities ( (("data"->>'arrival_date')) );
      CREATE INDEX block_availabilities_departure_date_index ON block_availabilities ( ((data->>'departure_date')) );
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX block_availabilities_hotel_id_index;
      DROP INDEX block_availabilities_arrival_date_index;
      DROP INDEX block_availabilities_departure_date_index;
    SQL
  end
end
