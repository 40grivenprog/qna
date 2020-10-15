FactoryBot.define do
  factory :badge do
    title { 'Badge' }

    user
    question

    before :create do |badge|
        badge.image.attach fixture_file_upload("#{Rails.root}/app/assets/images/badge-icon.png")
    end
  end
end
