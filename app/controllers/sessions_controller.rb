class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    response.headers.merge! @user.create_new_auth_token
    render json: @user
  end

  protected

  def auth_hash
    request.env['action_dispatch.request.unsigned_session_cookie']['dta.omniauth.auth']
  end
end
