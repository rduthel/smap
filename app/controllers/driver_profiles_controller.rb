class DriverProfilesController < ApplicationController

  before_action :set_user, only: [:profile, :edit, :update]



  def edit
    if flash.alert == "Vous devez renseigner votre permis et CI."
      flash.alert = "Vous devez renseigner votre permis et CI."
    end
  end

  def update
    @driver_profile.update(profile_params)
    @driver_profile.reload
    if flash.alert == "Vous devez renseigner votre permis et CI." && @driver_profile.driving_license? && @driver_profile.identity_card?
      redirect_to dashboard_path
      flash.notice = "Félicitations ! Votre soucription sera validée sous 48h"
    else
      redirect_to profil_path
    end
  end

  private

  def set_user
    @driver_profile = DriverProfile.find_by user: current_user
  end

  def profile_params
    params.require(:driver_profile).permit(:title, :first_name, :last_name, :address, :zip_code, :city, :birthdate, :telephone_number, :driving_license, :identity_card, :photo)
  end
end
