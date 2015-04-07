class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.string  :name
      t.float   :exact_class
      t.float   :review_score
      t.integer :booking_id
    end
  end
end
