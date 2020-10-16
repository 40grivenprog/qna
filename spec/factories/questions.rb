include ActionDispatch::TestProcess

FactoryBot.define do
  factory :question do
    user
    title { "Question" }
    body { "What is question?" }

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      before :create do |question|
        question.files.attach fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")
      end
    end
  end
end
