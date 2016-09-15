require 'rails_helper'

def gift_params
  {
    recipient: users(:user_one),
    name: 'A Gift',
    creator: users(:user_one),
    publicity: 'Public'
  }
end

RSpec.describe 'Gift' do
  fixtures :users

  it 'requires a recipient' do
    expect(Gift.create(gift_params.reject { |key, _value| key == :recipient })).to_not be_valid
    expect(Gift.create(gift_params)).to be_valid
  end

  it 'requires a name' do
    expect(Gift.create(gift_params.reject { |key, _value| key == :name })).to_not be_valid
  end

  it 'requires a suggestor (creator)' do
    expect(Gift.create(gift_params.reject { |key, _value| key == :creator })).to_not be_valid
  end

  it 'requires a publicity status' do
    expect(Gift.create(gift_params.reject { |key, _value| key == :publicity })).to_not be_valid
  end
end
