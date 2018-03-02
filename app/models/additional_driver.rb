class AdditionalDriver < ApplicationRecord
  belongs_to :driver_profile

  mount_uploader :photo, PhotoUploader
  mount_uploader :driving_license, PhotoUploader
  mount_uploader :identity_card, PhotoUploader
end
