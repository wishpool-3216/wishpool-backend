require 'rails_helper'

RSpec.describe 'Contribution requests' do
  fixtures :all

  it 'should return all the contributions to a gift' do
    gift = FactoryGirl.create(:gift)
    contribution = FactoryGirl.create(:contribution)
    gift.contributions << contribution
    get "/api/v1/gifts/#{gift.id}/contributions"
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    expect(response.body).to eq([contribution].to_json)
  end

  it 'should return a single contribution' do
    contribution = FactoryGirl.create(:contribution)
    get "/api/v1/contributions/#{contribution.id}"
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    expect(response.body).to eq(contribution.to_json)
  end

  it 'should create a new contribution to a gift' do
    gift = FactoryGirl.create(:gift)
    user = FactoryGirl.create(:user)
    expect do
      post "/api/v1/gifts/#{gift.id}/contributions", add_auth_to({ amount: 3 }, user)
    end.to change { Contribution.count }.by(1)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    expect(gift.contributions.length).to eq(1)
  end

  it 'should update the contribution to a gift' do
    contribution = FactoryGirl.create(:contribution)
    user = contribution.creator
    amt = Random.new.rand.round(2)
    patch "/api/v1/contributions/#{contribution.id}", add_auth_to({ amount: amt }, user)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    expect(Contribution.find(contribution.id).amount).to eq(amt)
  end

  it 'should remove a contribution' do
    contribution = FactoryGirl.create(:contribution)
    user = contribution.creator
    delete "/api/v1/contributions/#{contribution.id}", add_auth_to({}, user)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    expect { Contribution.find(contribution.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'should block unauthorized deletion and updating' do
    contribution = FactoryGirl.create(:contribution)
    user = FactoryGirl.create(:user)
    patch "/api/v1/contributions/#{contribution.id}", add_auth_to({ amount: 14 }, user)
    expect(response).to have_http_status(:forbidden)
    delete "/api/v1/contributions/#{contribution.id}", add_auth_to({}, user)
    expect(response).to have_http_status(:forbidden)
  end
end
