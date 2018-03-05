class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :driver_profile, dependent: :destroy
  accepts_nested_attributes_for :driver_profile

  devise :omniauthable, omniauth_providers: [:facebook]
  after_create :add_driver_profile

  def self.find_for_facebook_oauth(auth)
    ap auth.info
    ap auth.extra

    user_params = auth.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email)
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    user_params = user_params.to_h

    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      driver_profile_params = auth.info.slice(:first_name, :last_name)
      driver_profile_params[:remote_photo_url] = auth.info.image
      driver_profile_params[:birthdate] = Date.strptime(auth.extra.raw_info.birthday, '%m/%d/%Y')
      driver_profile_params[:city] = auth.info.location.split(',')[0]
      driver_profile_params[:title] = auth.extra.raw_info.gender == "male" ? "Mr" : "Mme"
      driver_profile_params = driver_profile_params.to_h

      user_params[:driver_profile_attributes] = driver_profile_params

      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
    end

    user
  end

  private

  def add_driver_profile
    self.create_driver_profile unless driver_profile
  end
end
