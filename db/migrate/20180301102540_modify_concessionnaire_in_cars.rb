class ModifyConcessionnaireInCars < ActiveRecord::Migration[5.1]
  def change
    remove_column :cars, :concessionnaire
    add_column :cars, :concessionnaire_name, :string
    add_column :cars, :concessionnaire_address, :string
  end
end
