FactoryGirl.define do
  factory :gift do
    name 'A Gift'
    association :creator, factory: :user
    association :recipient, factory: :user
    publicity 'Public'
  end
end
