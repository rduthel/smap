class Slot < ApplicationRecord


  belongs_to :address
  belongs_to :car
  validates :address, presence: true

end
