class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :name
      t.string :max_occupancy

      t.belongs_to :block_availability
    end

    add_index :blocks, :block_availability_id
  end
end
