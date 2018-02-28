class RemoveEmailFromDriverProfile < ActiveRecord::Migration[5.1]
  def change
    remove_column :driver_profiles, :email, :string
  end
end
