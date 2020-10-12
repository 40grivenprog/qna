require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { FactoryBot.create(:user) }
  given(:gist_url) { 'https://gist.github.com/40grivenprog/7a08f276fbab891486e43dbc9c169faf' }
  given(:google_url) { 'https://www.google.com/' }

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist 1'
    fill_in 'Link url', with: gist_url

    click_on 'Add one more link'

    within(:xpath, "//div[@class = 'nested-fields'][2]") do
      fill_in 'Link name', with: 'Google Link'
      fill_in 'Link url', with: google_url
    end

    click_on 'Ask'

    within(:xpath, "//div[@class = 'question']//div[@class = 'question-links-list']") do
      expect(page).to have_content 'Hello World'
      expect(page).to have_link 'Google Link', href: google_url
    end
  end
end
