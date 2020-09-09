FactoryBot.define do
  factory :question do
    user
    title { "Question" }
    body { "What is question?" }

    trait :invalid do
      title { nil }
    end
  end
end
