require 'rails_helper'

RSpec.describe 'Gift Requests' do
  fixtures :all

  def gift_params(user)
    {
      name: 'A Gift',
      publicity: 'Private',
      recipient_id: user.id
    }
  end

  def create_gift_for(user)
    user.gifts.create!(gift_params(user).merge!(creator_id: user.id))
  end

  it 'should create a new gift for a user' do
    @user = users(:user_one)
    expect do
      post "/api/v1/users/#{@user.id}/gifts", add_auth_to(gift_params(@user), @user)
    end.to change { Gift.count }.by(1)
    @gift = Gift.last
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    expect(@gift.recipient_id).to equal(@user.id)
    expect(@gift.creator_id).to equal(@user.id)
  end

  it 'should retrieve a particular gift' do
    user = users(:user_one)
    gift = create_gift_for(user)
    get "/api/v1/gifts/#{gift.id}"
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    expect(response.body).to eq(gift.to_json)
  end

  it 'should retrieve all the gifts of a user' do
    user = users(:user_one)
    gift = create_gift_for(user)
    get "/api/v1/users/#{user.id}/gifts"
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    expect(parseJSON(response.body).class).to eq(Array)
    expect(parseJSON(response.body).length).to eq(user.gifts.length)
    # parseJSON called on both sides to ensure Date formatting is consistent
    # serializable_hash used here instaed of to_json because it was called as a collection, so no include :whatever is called
    expect(parseJSON(response.body).first).to eq(parseJSON(gift.serializable_hash.to_json))
  end

  it 'should be able to change the status of a gift' do
    user = users(:user_one)
    gift = create_gift_for(user)
    patch "/api/v1/gifts/#{gift.id}", add_auth_to({ publicity: 'Public' }, user)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    expect(parseJSON(response.body)['publicity']).to eq('Public')
    expect(Gift.find(gift.id).publicity).to eq('Public')
  end

  it 'should delete a gift' do
    user = users(:user_one)
    gift = create_gift_for(user)
    expect do
      delete "/api/v1/gifts/#{gift.id}", add_auth_to({}, user)
    end.to change { Gift.count }.by(-1)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
  end

  it 'should block non-related users from modifying gifts or deleting gifts' do
    user = users(:user_one)
    wrong_user = users(:user_two)
    gift = create_gift_for(user)
    patch "/api/v1/gifts/#{gift.id}", add_auth_to({ publicity: 'Public'}, wrong_user)
    expect(response).to have_http_status(:forbidden)
    expect(response.content_type).to eq('application/json')
    expect(Gift.find(gift.id).publicity).to eq('Private')

    delete "/api/v1/gifts/#{gift.id}", add_auth_to({}, wrong_user)
    expect(response).to have_http_status(:forbidden)
    expect(response.content_type).to eq('application/json')
    expect(Gift.find(gift.id)).to_not eq(nil)
  end
end
