FactoryGirl.define do
  factory :user do
    sequence :uid do |n| "some_id#{n}" end
    provider 'facebook'
    password 'password'
    password_confirmation 'password'
  end
end
