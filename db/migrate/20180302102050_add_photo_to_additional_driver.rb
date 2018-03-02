class AddPhotoToAdditionalDriver < ActiveRecord::Migration[5.1]
  def change
    add_column :additional_drivers, :photo, :string
  end
end
