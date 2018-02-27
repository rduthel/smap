class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :driver_profile

  after_create :add_driver_profile


  private

  def add_driver_profile
    self.create_driver_profile
  end
end
