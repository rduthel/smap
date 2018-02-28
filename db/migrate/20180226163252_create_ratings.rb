class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.references :car, foreign_key: true
      t.string :user
      t.integer :rate

      t.timestamps
    end
  end
end
