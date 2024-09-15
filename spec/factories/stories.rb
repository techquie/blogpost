FactoryBot.define do
  factory :story do
    content       {'Test stories, this is story of thirsty crow.'}
    title         { 'Thirsty crow' }
    published     { true }
    association :user
  end
end
