# API for retrieving data about users
class UsersController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!, :reject_if_not_self,
                only: [:update, :friend_birthdays]

  ##
  # Retrieves data of a single user
  # GET '/api/v1/users/:id'
  def show
    render json: User.find(params[:id])
  end

  ##
  # Updates data of a single user
  # Returns the updated data
  # You can only update your own account
  # PATCH '/api/v1/users/:id'
  def update
    @user.update!(user_params)
    render json: @user
  end

  ##
  # Gets the list of friends with birthdays in the system
  # Returns an array of User objects with the keys
  # +id+ (our system), +uid+ (facebook) and +birthday+
  def friend_birthdays
    render json: @user.get_friends_by_birthday
  end

  private

  ##
  # Prevent people from trying to throw nonsense into the system
  def user_params
    permit = [
      :email, :password, :password_confirmation,
      :image, :name, :nickname, :oauth_token,
      :oauth_expires_at, :provider, :birthday
    ]
    params.permit(permit)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def reject_if_not_self
    return unless current_user != @user
    render json: {}, status: :forbidden
  end
end
