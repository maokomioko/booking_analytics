class DropPkFromFacilities < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE room_facilities DROP CONSTRAINT room_facilities_pkey'
    add_index :room_facilities, :id, unique: true
    change_column_default :room_facilities, :id, nil

    execute 'ALTER TABLE hotel_facilities DROP CONSTRAINT hotel_facilities_pkey'
    add_index :hotel_facilities, :id, unique: true
    change_column_default :hotel_facilities, :id, nil
  end

  def down
    remove_index :room_facilities, :id
    execute 'ALTER TABLE room_facilities ADD PRIMARY KEY (id)'
    execute "
      SELECT setval('room_facilities_id_seq', (SELECT coalesce(MAX(id), 0)::INTEGER + 1 from room_facilities), false);
      ALTER TABLE room_facilities ALTER COLUMN id SET DEFAULT nextval('room_facilities_id_seq'::regclass);
    "

    remove_index :hotel_facilities, :id
    execute 'ALTER TABLE hotel_facilities ADD PRIMARY KEY (id)'
    execute "
      SELECT setval('hotel_facilities_id_seq', (SELECT coalesce(MAX(id), 0)::INTEGER + 1 from hotel_facilities), false);
      ALTER TABLE hotel_facilities ALTER COLUMN id SET DEFAULT nextval('hotel_facilities_id_seq'::regclass);
    "
  end
end
