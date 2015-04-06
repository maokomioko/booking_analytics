class AddCurrentJobToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :current_job, :string
  end
end
