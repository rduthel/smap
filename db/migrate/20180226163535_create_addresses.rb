class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :address
      t.string :zip_code
      t.string :city
      t.references :driver, foreign_key: true

      t.timestamps
    end
  end
end
