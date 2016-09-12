require 'rails_helper'

describe Gift do
  it 'requires a recipient' do
    expect(Gift.create).to_not be_valid
  end
end
