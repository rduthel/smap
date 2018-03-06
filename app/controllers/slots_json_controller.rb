class SlotsJsonController < ApplicationController
  def create
    p '--------------------- Coucou je suis dans slotsJSON ---------------------'
    p Time.at(params['start'].to_i / 1000).to_datetime
    p Time.at(params['end'].to_i / 1000).to_datetime

  end
end
