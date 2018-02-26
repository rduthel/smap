class CreateAdditionalDrivers < ActiveRecord::Migration[5.1]
  def change
    create_table :additional_drivers do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.date :birthdate
      t.string :telephone_number
      t.string :email
      t.string :address
      t.string :zip_code
      t.string :city
      t.references :driver, foreign_key: true
      t.string :driving_license
      t.string :identity_card

      t.timestamps
    end
  end
end
