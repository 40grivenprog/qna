FactoryBot.define do
  factory :question do
    title { "Question" }
    body { "What is question?" }

    trait :invalid do
      title { nil }
    end
  end
end
