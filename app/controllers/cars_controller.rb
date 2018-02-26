class CarsController < ApplicationController

  def home
    @cars = Car.all
  end

  def index
    @cars = Car.all
  end

  def show
  end

  def estimation
  end

  def subscription
  end
end
