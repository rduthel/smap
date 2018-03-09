class AdditionalDriver < ApplicationRecord
  belongs_to :driver_profile, dependent: :destroy

  mount_uploader :photo, PhotoUploader
  mount_uploader :driving_license, PhotoUploader
  mount_uploader :identity_card, PhotoUploader

  after_create :set_default_values

  # def set_default_values
  #   # Only set if photo IS NOT set
  #   self.photo ||=   "profil.png"
  # end
end
