FactoryBot.define do
  factory :answer do
    question
    body { 'It is answer' }

    trait :invalid do
      body { nil }
    end
  end
end
