class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    session[:user_id] = @user.id
    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['action_dispatch.request.unsigned_session_cookie']['dta.omniauth.auth']
  end
end
