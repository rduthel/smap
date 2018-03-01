class AddConcessionnaireToCars < ActiveRecord::Migration[5.1]
  def change
    add_column :cars, :concessionnaire, :string
  end
end
