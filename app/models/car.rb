class Car < ApplicationRecord
  has_many :slots, dependent: :destroy
  has_many :ratings
end

