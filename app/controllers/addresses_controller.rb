class AddressesController < ApplicationController

  before_action :set_driver, only: [:edit, :create, :update, :destroy]

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.driver_profile = @driver_profile
    if @address.save
      redirect_to dashboard_slot_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @address.update(address_params)
    redirect_to dashboard_slot_path
  end

  def destroy
    @address.delete
    redirect_to dashboard_slot_path
  end

  private

  def set_driver
    @driver_profile = DriverProfile.find_by user: current_user
    @address = Address.find_by driver_profile: @driver_profile
  end

  def address_params
    params.require(:address).permit(:name, :address, :zip_code, :city)
  end

end
