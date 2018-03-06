class Slot < ApplicationRecord


  belongs_to :address, dependent: :destroy
  belongs_to :car
  validates :address, presence: true

end
