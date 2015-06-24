class CreateRoomSettings < ActiveRecord::Migration
  def up
    create_table :room_settings do |t|
      t.integer :position
      t.belongs_to :room
      t.belongs_to :setting

      t.timestamps
    end

    say_with_time 'create room rankings for existed settings' do
      Setting.find_each do |setting|
        setting.send(:create_room_settings)
      end
    end
  end

  def down
    drop_table :room_settings
  end
end
