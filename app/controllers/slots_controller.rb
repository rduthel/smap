class SlotsController < ApplicationController
  def new
    set_driver_addresses
    @slot = Slot.new
  end

  def create
    @driver_profile = DriverProfile.find_by user: current_user
    @slot = Slot.new(slot_params)
    @slot.car = @driver_profile.car
    if @slot.save
      redirect_to dashboard_slot_path
    else
      render :new
    end
  end

  def edit
    set_driver_addresses
    @slot = Slot.find(params[:id])
  end

  def update
    @slot = Slot.find(params[:id])
    @slot.update(slot_params)
    redirect_to dashboard_slot_path
  end

  def destroy
    @slot = Slot.find(params[:id])
    @slot.delete
    redirect_to dashboard_slot_path
  end

  private

  def set_driver_addresses
    @driver_profile = DriverProfile.find_by user: current_user
    @addresses = Address.where(driver_profile: @driver_profile)
  end

  def slot_params
    params.require(:slot).permit(:from, :to, :address, :address_id)
  end

end
