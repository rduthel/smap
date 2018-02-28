class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars do |t|
      t.string :category
      t.string :brand
      t.string :model
      t.string :energy
      t.integer :monthly_price
      t.integer :seat
      t.integer :lugage
      t.string :transmission
      t.string :engine
      t.integer :car_door
      t.text :description

      t.timestamps
    end
  end
end
