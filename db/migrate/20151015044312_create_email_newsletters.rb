class CreateEmailNewsletters < ActiveRecord::Migration
  def change
    create_table :email_newsletters do |t|
      t.string :type
      t.string :string
      t.string :hotel_id
      t.string :integer

      t.timestamps
    end

    add_index :email_newsletters, :hotel_id
  end
end
