class AddTransliterationToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :normalized_name, :string
  end
end
