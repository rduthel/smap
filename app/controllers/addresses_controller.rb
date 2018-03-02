class AddressesController < ApplicationController

  before_action :set_driver, only: [:create, :update, :destroy]

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
  end

  def destroy
  end

  private

  def set_driver
    @driver_profile = DriverProfile.find_by user: current_user
  end

  def address_params
    params.require(:address).permit(:name, :address, :zip_code, :city)
  end

end
