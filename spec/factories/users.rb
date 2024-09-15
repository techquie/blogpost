FactoryBot.define do
  factory :user do
    name              {'Test User Kumar'}
    sequence(:email)  { |n| "user#{n}@example.com" }
    password          {'123456'}
    role              { 'admin' }
  end
end
