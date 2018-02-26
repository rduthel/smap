class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.referencesuser :car
      t.integer :rate

      t.timestamps
    end
  end
end
