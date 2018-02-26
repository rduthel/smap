class CreateSlots < ActiveRecord::Migration[5.1]
  def change
    create_table :slots do |t|
      t.datetime :from
      t.datetime :to
      t.references :address, foreign_key: true
      t.references :car, foreign_key: true

      t.timestamps
    end
  end
end
