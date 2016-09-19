require 'rails_helper'

##
# Contains Integration tests for the Users API
RSpec.describe 'User requests', type: :request do
  fixtures :all

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
    expect(response.headers).to have_key('Access-Control-Allow-Origin')
    expect(response.headers).to have_key('Access-Control-Allow-Headers')
    expect(response.headers).to have_key('Access-Control-Max-Age')
    expect(response.headers).to have_key('Access-Control-Allow-Methods')
  end

  it 'fails to signs in a User' do
    @user = users(:user_one)
    # Password is hard coded in fixture
    post '/auth/sign_in', email: @user.email, password: 'wrong_password'
    expect(response).to have_http_status(:unauthorized)
    expect(response.headers).to_not have_key('access-token')
  end

  # Desperately need a way to test FB OAuth sign_in

  # Desperately need a way to test that OAuth sign_in returns auth headers

  it 'should reject wrongly signed in users' do
    wrong_user = User.create(email: 'a@b.com', password: 'password', password_confirmation: 'password')
    user = users(:user_one)
    get "/api/v1/users/#{wrong_user.id}/friend_birthdays", add_auth_to({}, user)
    expect(response).to have_http_status(:forbidden)
  end

  it 'returns the json representation of a user' do
    @user = users(:user_one)
    get "/api/v1/users/#{@user.id}"
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    expect(response.body).to eq(@user.to_json)
    expect(parseJSON(response.body)).to have_key('gifts')
  end

  it 'updates an attribute of a user, in this case the nickname' do
    @user = users(:user_one)
    patch "/api/v1/users/#{@user.id}",
          add_auth_to({ nickname: 'My new nickname' }, @user)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    # Compare with both the actual database value and the response hash
    expect(parseJSON(response.body)['nickname']).to eq('My new nickname')
    expect(User.find(@user.id).nickname).to eq('My new nickname')
  end

  it 'gets the birthdays of friends in the upcoming sort order' do
    # This test only verifies that the endpoint exists
    @user = users(:user_one)
    get "/api/v1/users/#{@user.id}/friend_birthdays", add_auth_to({}, @user)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
  end
end
