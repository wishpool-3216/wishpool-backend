class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  model_stamper

  has_many :gifts

  def self.find_or_create_from_auth_hash(auth)
    user = where(provider: auth['provider'], uid: auth['uid']).first_or_create
    user.provider = auth['provider']
    user.uid = auth['uid']
    user.name = auth['info']['name']
    user.oauth_token = auth['credentials']['token']
    user.oauth_expires_at = Time.at(auth['credentials']['expires_at'])
    user.save!(validate: false)
    user
  end
end
