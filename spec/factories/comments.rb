FactoryBot.define do
  factory :comment do
    body { "Body" }
    user
    association :commentable, factory: :question
  end
end
