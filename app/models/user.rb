class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :driver_profile, dependent: :destroy

  devise :omniauthable, omniauth_providers: [:facebook]

  def self.find_for_facebook_oauth(auth)
    p "---------------"
    ap auth
    p"----------------"
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
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save
      driver_profile_params = auth.info.slice(:first_name, :last_name)
      driver_profile_params[:remote_photo_url] = auth.info.image
      driver_profile_params.merge!(user: user)
      p "--------------"
      p auth.info.location
      p date = auth.extra.raw_info.birthday
      p "----"
      p Date.strptime(date, '%m/%d/%Y')
      p auth.extra.raw_info.gender
      p "--------------"
      driver_profile_params = driver_profile_params.to_h
      DriverProfile.create(driver_profile_params)
    end

    return user
  end
end
