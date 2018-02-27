class Slot < ApplicationRecord
  belongs_to :address
  belongs_to :car
end
