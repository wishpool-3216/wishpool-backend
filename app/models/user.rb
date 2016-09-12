require 'date'

class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  model_stamper

  has_many :gifts

  after_create :get_birthday

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

  def get_birthday
    return birthday if birthday
    birthday = Date.strptime(Koala::Facebook::API.new(oauth_token).get_object('me?fields=birthday')['birthday'], '%m/%d/%Y')
    update(birthday: birthday)
    birthday
  end

  def get_friends_by_birthday
    sorted_by_date = Koala::Facebook::API.new(oauth_token).get_connections('me', 'friends?fields=name,birthday').
                     select { |friend| friend['birthday'] }.
                     each { |friend| friend['birthday'] = Date.strptime(friend['birthday'], '%m/%d/%Y') }.
                     sort_by { |friend| friend['birthday'] }
    today = Date.today - Date.today.beginning_of_year
    sorted_by_date.select { |friend| friend['birthday'] - friend['birthday'].beginning_of_year >= today } +
      sorted_by_date.select { |friend| friend['birthday'] - friend['birthday'].beginning_of_year < today }
  end
end
