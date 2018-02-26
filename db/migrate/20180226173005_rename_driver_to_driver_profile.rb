class RenameDriverToDriverProfile < ActiveRecord::Migration[5.1]
  def change
    remove_reference :addresses, :driver
    remove_reference :additional_drivers, :driver
    drop_table :drivers

    create_table :driver_profiles do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.date :birthdate
      t.string :telephone_number
      t.string :email
      t.string :address
      t.string :zip_code
      t.string :city
      t.references :car, foreign_key: true
      t.string :driving_license
      t.string :identity_card
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_reference :addresses, :driver_profile, foreign_key: true
    add_reference :additional_drivers, :driver_profile, foreign_key: true

  end
end
