class AddGlobalStrategyToAlgorithm < ActiveRecord::Migration
  def change
    add_column :settings, :strategy, :string
  end
end
