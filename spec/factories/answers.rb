include ActionDispatch::TestProcess

FactoryBot.define do
  factory :answer do
    question
    user
    body { 'It is answer' }

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      before :create do |answer|
        answer.files.attach fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")
      end
    end
  end
end
