class AdditionalDriversController < ApplicationController

  before_action :set_user, only: [:edit, :update]

  def new
    @additional_driver = AdditionalDriver.new
  end

  def create
    @additional_driver = AdditionalDriver.new(additional_driver_params)
    @driver_profile = DriverProfile.find_by user: current_user
    @additional_driver.driver_profile = @driver_profile
    if @additional_driver.save
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @additional_driver.update(additional_driver_params)
    redirect_to dashboard_path
  end

  private

  def set_user
    @driver_profile = DriverProfile.find_by user: current_user
    @additional_driver = AdditionalDriver.find_by driver_profile: @driver_profile
  end

  def additional_driver_params
    params.require(:additional_driver).permit(:photo, :title, :first_name, :last_name, :birthdate, :telephone_number, :address, :zip_code, :city, :driving_license, :identity_card)
  end
end
