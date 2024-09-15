FactoryBot.define do
  factory :comment do
    content                 {'Nice stories'}
    approved_by_admin       { false }
    approved_by_sadmin      { false }
    association :story
  end
end
