class DriverProfilesController < ApplicationController

  before_action :set_user, only: [:profile, :edit, :update]

  def profile

  end

  def edit

  end

  def update
    @driver_profile.update(profile_params)
    redirect_to profil_path
  end

  private

  def set_user
    @driver_profile = DriverProfile.find_by user: current_user
  end

  def profile_params
    params.require(:driver_profile).permit(:title, :first_name, :last_name, :email, :address, :zip_code, :city, :birthdate, :telephone_number, :driving_license, :identity_card, :photo)
  end
end
