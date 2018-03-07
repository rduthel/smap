class SlotsJsonController < ApplicationController
  def create
    Slot.create!(
      address_id: Address.where(name: params['title']).first.id,
      car_id: Car.first.id,
      from: time_to_readable_date(params['start']),
      to: time_to_readable_date(params['end'])
    )
  end

  private

  def time_to_readable_date(time)
    Time.at(time.to_i / 1000).to_datetime
  end
end
