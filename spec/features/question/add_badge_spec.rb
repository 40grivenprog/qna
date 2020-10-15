require 'rails_helper'

feature 'User can add badge to question', %q{
  In order to give a badge for best answer to my question
  As an question's author
  I'd like to be able to add badge
} do
  given(:user) { FactoryBot.create(:user) }

  scenario 'User adds badge when asks question', js: true do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within('div#new-badge') do
      fill_in 'Badge title', with: 'Badge title'
      attach_file 'Image', "#{Rails.root}/app/assets/images/badge-icon.png"
    end

    click_on 'Ask'
    within '.question' do
      expect(page).to have_content 'Badge title'
      expect(page).to have_xpath("//img")
    end
  end
end
