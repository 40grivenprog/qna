FactoryBot.define do
  factory :vote do
    score { 1 }
    association :voteable, factory: :question
    user
  end
end
