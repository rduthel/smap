class Address < ApplicationRecord
  belongs_to :driver_profile
  has_many :slots
end

