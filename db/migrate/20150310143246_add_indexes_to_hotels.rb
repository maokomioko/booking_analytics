class AddIndexesToHotels < ActiveRecord::Migration
  def change
    add_index :hotels, [:exact_class, :review_score]
  end
end
