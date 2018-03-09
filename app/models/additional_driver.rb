class AdditionalDriver < ApplicationRecord
  belongs_to :driver_profile, dependent: :destroy

  mount_uploader :photo, PhotoUploader
  mount_uploader :driving_license, IdUploader
  mount_uploader :identity_card, IdUploader

end
