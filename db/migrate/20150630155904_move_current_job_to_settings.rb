class MoveCurrentJobToSettings < ActiveRecord::Migration
  def change
    remove_column :hotels, :current_job, :string
    add_column :settings, :current_job, :string
    add_column :settings, :sidekiq_lock, :boolean, default: false
  end
end
