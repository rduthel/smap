class RemoveEngineFromCar < ActiveRecord::Migration[5.1]
  def change
    remove_column :cars, :engine, :string
  end
end
