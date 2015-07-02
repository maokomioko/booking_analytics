class ChangeHotelDistrictColumnType < ActiveRecord::Migration
  def up
    if Hotel.columns_hash["district"].type == :array
      remove_index :hotels, :district
      execute 'ALTER TABLE hotels ALTER COLUMN district TYPE varchar USING (district[1]::varchar);'
      add_index :hotels, :district
    end
  end

  def down
    remove_index :hotels, :district
    execute 'ALTER TABLE hotels ALTER COLUMN district TYPE text[] USING (ARRAY[district]);'
    execute "ALTER TABLE hotels ALTER COLUMN district SET DEFAULT '{}';"
    add_index :hotels, :district, using: :gin
  end
end
