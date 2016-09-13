require 'date'

class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  model_stamper

  has_many :gifts, foreign_key: :recipient_id
  has_many :created_gifts, foreign_key: :creator_id, class_name: 'Gift'

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
  rescue Koala::Facebook::AuthenticationError
    # Don't do anything.
  end

  def get_friends_by_birthday
    friends = Koala::Facebook::API.new(oauth_token).get_connections('me', 'friends?uid').
              map { |friend| friend['id'] }
    user_friends = User.where(uid: friends)
                     # select { |friend| friend['birthday'] }.
                     # each { |friend| friend['birthday'] = Date.strptime(friend['birthday'], '%m/%d/%Y') }.
                     # sort_by { |friend| friend['birthday'] }
    today = Date.today - Date.today.beginning_of_year
    sorted_by_date = user_friends.sort_by { |friend| friend.birthday - friend.birthday.beginning_of_year }
    sorted_by_date.select { |friend| friend.birthday - friend.birthday.beginning_of_year >= today } +
      sorted_by_date.select { |friend| friend.birthday - friend.birthday.beginning_of_year < today }
  end
end
