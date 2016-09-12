require 'rails_helper'

def create_gift
  Gift.create!(recipient: users(:user_one), name: 'A Gift', creator: users(:user_one), publicity: 'Public')
end

describe Contribution do
  fixtures :users

  it 'belongs to a gift' do
    g = create_gift
    expect(Contribution.create(amount: 1)).to_not be_valid
    expect(Contribution.create(gift: g, amount: 1, creator: users(:user_one))).to be_valid
  end

  it 'has a non-negative amount' do
    g = create_gift
    expect(Contribution.create(gift: g, creator: users(:user_one))).to_not be_valid
    expect(Contribution.create(gift: g, amount: -1, creator: users(:user_one))).to_not be_valid
    expect(Contribution.create(gift: g, amount: 0, creator: users(:user_one))).to_not be_valid
    expect(Contribution.create(gift: g, amount: 1.23, creator: users(:user_one))).to be_valid
  end

  it 'has a contributor (aka creator)' do
    g = create_gift
    expect(Contribution.create(gift: g, amount: 1)).to_not be_valid
    expect(Contribution.create(gift: g, amount: 1, creator: users(:user_one))).to be_valid
  end
end
