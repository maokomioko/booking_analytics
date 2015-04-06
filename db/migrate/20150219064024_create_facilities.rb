class CreateFacilities < ActiveRecord::Migration
  def up
    create_table :hotel_facilities do |t|
      t.string :name
      t.integer :count, default: 0
    end

    create_table :hotel_facilities_hotels, id: false do |t|
      t.references :hotel_facility
      t.references :hotel
    end

    add_index :hotel_facilities_hotels, [:hotel_facility_id, :hotel_id]
    add_index :hotel_facilities_hotels, :hotel_id

    create_table :room_facilities do |t|
      t.string :name
      t.integer :count, default: 0
    end

    create_table :room_facilities_rooms, id: false do |t|
      t.references :room_facility
      t.references :room
    end

    add_index :room_facilities_rooms, [:room_facility_id, :room_id]
    add_index :room_facilities_rooms, :room_id

    execute "
      create or replace function trigger_update_facilities_count() returns trigger as $$
        declare
          ref_table varchar;
          foreign_key varchar;
          foreign_id integer;
        begin
          ref_table   := TG_ARGV[0];
          foreign_key := TG_ARGV[1];

          if TG_OP = 'INSERT' then
            EXECUTE format('SELECT ($1).%I', foreign_key) USING NEW INTO foreign_id;
            execute 'UPDATE ' || ref_table || ' SET count = count + 1 WHERE id = ' || foreign_id;
            return NEW;
          elsif TG_OP = 'DELETE' then
            EXECUTE format('SELECT ($1).%I', foreign_key) USING OLD INTO foreign_id;
            execute 'UPDATE ' || ref_table || ' SET count = count - 1 WHERE id = ' || foreign_id;
            return OLD;
          end if;
        end;
      $$ language plpgsql; "

    execute %q{
            create trigger "update_hotel_facilities_count"
                after insert or delete
                on "hotel_facilities_hotels"
                for each row
            execute procedure "trigger_update_facilities_count"("hotel_facilities", "hotel_facility_id");
            }

    execute %q{
            create trigger "update_room_facilities_count"
                after insert or delete
                on "room_facilities_rooms"
                for each row
            execute procedure "trigger_update_facilities_count"("room_facilities", "room_facility_id");
            }
  end

  def down
    drop_table :hotel_facilities
    drop_table :hotel_facilities_hotels

    drop_table :room_facilities
    drop_table :room_facilities_rooms
  end
end
