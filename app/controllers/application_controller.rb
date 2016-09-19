class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  after_filter :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = ['GET, POST, PATCH, DELETE']
    headers['Access-Control-Allow-Headers'] = ['Origin, Content-Type, Accept, Authorization, access-token, bearer, uid, expiry, client, If-Modified-Since']
    headers['Access-Control-Max-Age'] = "1728000"
    headers['Access-Control-Expose-Headers'] = ['access-token, token-type, client, expiry, uid']
  end

  def cor
    render text: ''
  end
end
