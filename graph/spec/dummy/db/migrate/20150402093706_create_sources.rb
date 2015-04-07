class CreateSources < ActiveRecord::Migration
  def change
    create_table Graph.source_table.to_sym do |t|
      t.jsonb :data
      t.text :max_occupancy, array: true, default: []
      t.integer :booking_id
    end

    add_index :sources, :booking_id
  end
end
