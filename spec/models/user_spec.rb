require 'rails_helper'

RSpec.describe 'User' do
  PROVIDER = 'facebook'.freeze
  UID = '12345'.freeze
  OAUTH = '124424'.freeze
  EXPIRY = Time.new.freeze
  AUTH = [
    PROVIDER, UID, OAUTH, EXPIRY
  ].freeze

  it 'should create a new user if one does not exist' do
    expect do
      @user = User.find_or_create_from_auth_hash(*AUTH)
    end.to change { User.count }.by(1)
    expect(@user.oauth_token).to eq(OAUTH)
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

  it 'should return the number of days between that day and 1st Jan' do
    expect(User.new.send(:ordinal_date, Date.today.beginning_of_year)).to eq(0)
  end

  it 'should not reveal the oauth key and the expiry when sent as json' do
    user = FactoryGirl.create(:user)
    expect(parseJSON(user.to_json)).to_not have_key('oauth_token')
    expect(parseJSON(user.to_json)).to_not have_key('oauth_expires_at')
  end
end
