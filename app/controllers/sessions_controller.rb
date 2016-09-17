require 'json'

class SessionsController < ApplicationController
  ##
  # POST /auth/facebook/callback
  def create
    # Basically test that the user token is legit, if not just reject them
    unless HTTParty.get("https://graph.facebook.com/debug_token?
      input_token=#{params[:access_token]}
      &access_token=#{ENV['WISHPOOL_FB_ACCESS_TOKEN']}")['data']['is_valid']
      render json: { errors: 'Your token is invalid' }, status: :forbidden
      return
    end
    @user = User.find_or_create_from_auth_hash(params[:provider], params[:uid], params[:access_token], params[:expires_in])
    response.headers.merge! @user.create_new_auth_token
    render json: @user
  rescue TypeError
    render json: { error: 'An error has occured. Are you sure you asked for the correct permissions from the user?' }, status: 500
  end

  protected

  def auth_hash
    request.env['action_dispatch.request.unsigned_session_cookie']['dta.omniauth.auth']
  end
end
