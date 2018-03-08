class DriverProfile < ApplicationRecord
  belongs_to :car, optional: true
  belongs_to :user
  has_many :additional_drivers, dependent: :destroy
  has_many :addresses, dependent: :destroy
  mount_uploader :photo, PhotoUploader
  mount_uploader :driving_license, PhotoUploader
  mount_uploader :identity_card, PhotoUploader

  delegate :email, to: :user
end

