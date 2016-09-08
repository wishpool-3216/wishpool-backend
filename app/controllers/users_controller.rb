# API for retrieving data about users
class UsersController < ApplicationController
  before_action :authenticate_user!, only: :update

  ##
  # Retrieves data of a single user
  # GET '/api/v1/users/:id'
  def show
    respond_to do |format|
      format.json { render json: User.find(params[:id]) }
    end
  end

  ##
  # Updates data of a single user
  # Returns the updated data
  # You can only update your own account
  # PATCH '/api/v1/users/:id'
  def update
    @user = User.find(params[:id])
    if current_user != @user
      respond_to do |format|
        format.json { render json: {}, status: :forbidden }
      end
      return
    end
    @user.update!(user_params)
    respond_to do |format|
      format.json { render json: @user }
    end
  end

  private

  def user_params
    permit = [
      :email, :password, :password_confirmation,
      :image, :name, :nickname, :oauth_token,
      :oauth_expires_at, :provider
    ]
    params.permit(permit)
  end
end
