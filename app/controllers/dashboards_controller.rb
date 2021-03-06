class DashboardsController < ApplicationController

  before_action :set_user

  def show
    @car = @driver_profile.car
  end

  def bill
  end

  def slot
  end

  def profile
    @driver_profile = DriverProfile.find_by user: current_user
    @car = @driver_profile.car
  end

  private

  def set_user
    @driver_profile = DriverProfile.find_by user: current_user
  end
end
