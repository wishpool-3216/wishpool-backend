require 'rails_helper'

describe User do
  AUTH = [
    'facebook',
    '12345',
    '16931248',
    Time.new
  ].freeze

  it 'should create a new user if one does not exist' do
    expect do
      User.find_or_create_from_auth_hash(*AUTH)
    end.to change { User.count }.by(1)
  end

  it 'should update the token of an existing user' do
    User.find_or_create_from_auth_hash(*AUTH)
    expect do
      auth = AUTH.dup
      auth[2] = 'new_token'
      @user = User.find_or_create_from_auth_hash(*auth)
    end.to_not change { User.count }
    expect(@user.oauth_token).to eq('new_token')
  end

  it 'should return a sorted array of users, with birthdays in ascending order'
end
