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

  ##
  # Creates a User if there isn't one already in the database
  # Auth hash comes from Facebook (see SessionsController)
  def self.find_or_create_from_auth_hash(provider, uid, access_token, expires_in)
    user = where(provider: provider, uid: uid).first_or_create
    user.provider = provider
    user.uid = uid

    # user.name = auth['info']['name']
    user.oauth_token = access_token
    user.oauth_expires_at = Time.at(expires_in.to_i)
    user.save!(validate: false)
    user
  end

  ##
  # On create, the user's birthday is stored in our system
  # This allows us to provide the functionality of retrieving the user's friends' birthdays
  # On failure (user somehow hides the birthday completely / UID is invalid), do nothing
  # If a user's birthday is already in our system, returns it immediately
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
    sorted_by_date = user_friends.sort_by { |friend| friend.get_birthday - friend.get_birthday.beginning_of_year }
    sorted_by_date.select { |friend| friend.get_birthday - friend.get_birthday.beginning_of_year >= today } +
      sorted_by_date.select { |friend| friend.get_birthday - friend.get_birthday.beginning_of_year < today }
  rescue Koala::Facebook::AuthenticationError
    [] # No Facebook = No friends. Sorry!
  end
end
