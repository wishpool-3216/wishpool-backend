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
  after_create :get_name

  ##
  # Override the default to_json method
  # This stops rendering users from showing the OAuth token and expiry
  def to_json(options={})
    options[:except] ||= [:oauth_token, :oauth_expires_at]
    super(options)
  end

  ##
  # Creates a User if there isn't one already in the database
  # Auth hash comes from Facebook (see SessionsController)
  def self.find_or_create_from_auth_hash(provider, uid, access_token, expires_in)
    user = where(provider: provider, uid: uid).first_or_create
    user.provider = provider
    user.uid = uid
    user.oauth_token = access_token
    user.oauth_expires_at = Time.at(expires_in.to_i)
    user.save!(validate: false)
    user
  end

  ##
  # On create, the user's name is stored in our system
  def get_name
    name = Koala::Facebook::API.new(oauth_token).get_object('me?fields=name')['name']
    update(name: name)
    name
  rescue Koala::Facebook::AuthenticationError
    # Do nothing.
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
    today = ordinal_date(Date.today)
    sorted_by_date = user_friends.sort_by { |friend| ordinal_date(friend.birthday) }
    sorted_by_date.select { |friend| ordinal_date(friend.birthday) >= today } +
      sorted_by_date.select { |friend| ordinal_date(friend.birthday) < today }
  rescue Koala::Facebook::AuthenticationError
    [] # No Facebook = No friends. Sorry!
  end

  private

  ##
  # Returns the number of days between a given date and the beginning of the year
  def ordinal_date(date)
    date - date.beginning_of_year
  end
end
