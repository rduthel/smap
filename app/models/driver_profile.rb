class DriverProfile < ApplicationRecord
  belongs_to :car, optional: true
  belongs_to :user
  has_many :additional_drivers
  has_many :addresses
end

