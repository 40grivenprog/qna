FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://gist.github.com/40grivenprog/4054b53640f9ea854b6082eca4a43f5b" }
    association :linkable, factory: :question

    trait :for_answer do
      association :linkable, factory: :answer
    end

    trait :invalid do
      url { 'string' }
    end
  end
end
