require 'rails_helper'

describe Contribution do
  fixtures :users

  it 'belongs to a gift' do
    Gift.create!(recipient: users(:user_one), name: 'A Gift')
    expect(Contribution.create(amount: 1)).to_not be_valid
    expect(Contribution.create(gift: Gift.first, amount: 1)).to be_valid
  end

  it 'has a non-negative amount' do
    g = Gift.create!(recipient: users(:user_one), name: 'A Gift')
    expect(Contribution.create(gift: g)).to_not be_valid
    expect(Contribution.create(gift: g, amount: -1)).to_not be_valid
    expect(Contribution.create(gift: g, amount: 0)).to_not be_valid
    expect(Contribution.create(gift: g, amount: 1.23)).to be_valid
  end
end
