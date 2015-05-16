class AddDistrictsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :districts, :text, array: true, default: []
  end
end
