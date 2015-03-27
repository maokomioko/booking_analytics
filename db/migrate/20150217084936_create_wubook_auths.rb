class CreateWubookAuths < ActiveRecord::Migration
  def change
    create_table(:wubook_auths) do |t|
      t.string :login
      t.string :password

      t.string :lcode
      t.integer :booking_id
      t.string :hotel_name

      t.integer :non_refundable_pid
      t.integer :default_pid

      t.belongs_to :user
    end

    add_index :wubook_auths, :user_id
  end
end
