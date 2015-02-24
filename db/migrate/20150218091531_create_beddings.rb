class CreateBeddings < ActiveRecord::Migration
  def change
    create_table :beddings do |t|
      t.belongs_to :room
    end

    create_table :beds do |t|
      t.string :amount
      t.string :type
      t.belongs_to :bedding
    end
  end
end
