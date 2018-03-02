class CarsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :index, :show, :estimation]

  def home
    @cars = Car.all
  end

  def index
    @cars = Car.all
  end

  def show
    @car = Car.find(params[:id])
  end

  def estimation
    @car = Car.find(params[:id])
  end

  def souscription
    @car = Car.find(params[:id])
    @driver_profile = DriverProfile.find_by user: current_user
    @driver_profile.car = @car
    if @driver_profile.save
      redirect_to dashboard_path
    else
      render :estimation
    end
  end
end
