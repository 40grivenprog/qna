require 'rails_helper'

feature 'User can delete a question if user is an author', %q{
  In order to help another users from a community a want to remove my question if it's incorrect
  As an authencated User
  I'd like to be able to remove my questions
} do

  given(:user1) { FactoryBot.create(:user) }
  given(:user2) { FactoryBot.create(:user) }
  given!(:question) { FactoryBot.create(:question, title: 'Test Title', user: user1) }

  describe 'Authenticated user' do
    scenario 'User removes his questions' do
      sign_in(user1)

      visit questions_path

      click_on id: "delete-#{question.id}-question"
      expect(page).not_to have_content(question.title)
    end

    scenario 'User removes not his question' do
      sign_in(user2)

      visit questions_path

      expect(page).to_not have_selector(:xpath, "//a[@id = 'delete-#{question.id}-question']")
    end
  end

  scenario 'user removes question' do
    visit questions_path

    expect(page).to_not have_selector(:xpath, "//a[@id = 'delete-#{question.id}-question']")
  end
end
