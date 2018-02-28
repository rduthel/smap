class CarsController < ApplicationController
  skip_before_action :authenticate_user!

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
