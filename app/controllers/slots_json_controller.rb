class SlotsJsonController < ApplicationController
  def create
    Slot.create!(
      address_id: Address.first.id,
      car_id: Car.first.id,
      from: Time.at(params['start'].to_i / 1000).to_datetime,
      to: Time.at(params['end'].to_i / 1000).to_datetime
    )
  end
end
