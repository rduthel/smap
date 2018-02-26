class DriverProfile < ApplicationRecord
  belongs_to :car
  belongs_to :user
  has_many :additional_drivers
  has_many :addresses
end

