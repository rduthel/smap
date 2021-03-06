class SlotsJsonController < ApplicationController
  def create
    Slot.create!(
      address_id: Address.where(name: params['address']).first.id,
      car_id: set_driver_car.id,
      from: time_to_readable_date(params['from']),
      to: time_to_readable_date(params['to'])
    )
  end

  private

  def time_to_readable_date(time)
    Time.at(time.to_i / 1000).to_datetime
  end

  def set_driver_car
    @driver_profile = DriverProfile.find_by user: current_user
    @car            = @driver_profile.car
  end
end
