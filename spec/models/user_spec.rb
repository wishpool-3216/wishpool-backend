require 'rails_helper'

describe User do
  AUTH_HASH = {
    'provider' => 'facebook',
    'uid' => '12345',
    'info' => {
      'name' => 'Test User'
    },
    'credentials' => {
      'token' => '16938',
      'expires_at' => Time.new
    }
  }.freeze

  it 'should create a new user if one does not exist' do
    expect do
      User.find_or_create_from_auth_hash(AUTH_HASH)
    end.to change { User.count }.by(1)
  end

  it 'should update the token of an existing user' do
    User.find_or_create_from_auth_hash(AUTH_HASH)
    expect do
      auth = AUTH_HASH.dup
      auth['credentials']['token'] = 'new_token'
      @user = User.find_or_create_from_auth_hash(auth)
    end.to_not change { User.count }
    expect(@user.oauth_token).to eq('new_token')
  end

  it 'should return a sorted array of users, with birthdays in ascending order'
end
