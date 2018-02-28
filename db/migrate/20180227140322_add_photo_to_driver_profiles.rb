class AddPhotoToDriverProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_profiles, :photo, :string
  end
end
