FactoryGirl.define do
  factory :contribution do
    amount 1
    association :gift, factory: :gift
    association :creator, factory: :user
  end
end
