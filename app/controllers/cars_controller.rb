class CarsController < ApplicationController
  def home
    @cars = Car.all
  end

  def index
    @cars = Car.all
  end

  def show
    @car = Car.find(params[:id])
  end

  def estimation; end

  def subscription; end
end
