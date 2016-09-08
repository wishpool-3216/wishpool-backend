require 'rails_helper'

##
# Contains Integration tests for the Users API
RSpec.describe 'User requests', type: :request do
  fixtures :users

  it 'creates a new User' do
    expect do
      post '/auth', email: 'test@example.com', password: 'Password', password_confirmation: 'Password'
    end.to change { User.count }.by(1)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    expect(response.headers).to have_key('access-token')
    expect(response.headers).to have_key('client')
    expect(response.headers).to have_key('uid')
    expect(response.headers).to have_key('expiry')
    expect(response.headers).to have_key('token-type')
  end

  it 'fails to create a new User' do
    expect do
      post '/auth', email: 'test@example.com', password: 'password', password_confirmation: 'Password'
    end.to_not change { User.count }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.content_type).to eq('application/json')
    expect(response.headers).to_not have_key('access-token')
  end

  it 'signs in a User' do
    @user = users(:user_one)
    # Password is hard coded in fixture
    post '/auth/sign_in', email: @user.email, password: 'password'
    expect(response).to have_http_status(:ok)
    expect(response.headers).to have_key('access-token')
    expect(response.headers).to have_key('client')
    expect(response.headers).to have_key('uid')
    expect(response.headers).to have_key('expiry')
    expect(response.headers).to have_key('token-type')
  end

  it 'fails to signs in a User' do
    @user = users(:user_one)
    # Password is hard coded in fixture
    post '/auth/sign_in', email: @user.email, password: 'wrong_password'
    expect(response).to have_http_status(:unauthorized)
    expect(response.headers).to_not have_key('access-token')
  end
end
