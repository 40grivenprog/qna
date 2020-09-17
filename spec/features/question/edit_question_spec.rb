require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my question
} do

  given(:user1) { FactoryBot.create(:user) }
  given(:user2) { FactoryBot.create(:user) }
  given!(:question) { FactoryBot.create(:question, user: user1) }

  scenario 'Unauthenticated can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true  do
    scenario 'edits his answer' do
      sign_in user1

      visit questions_path

      click_on 'Edit'

      within '.questions' do
        fill_in 'Your Question title', with: 'edited question title'
        fill_in 'Your Question body', with: 'edited question body'
        click_on 'Save'
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to_not have_selector 'edited question body'
      end
    end

    scenario 'edits his answer with errors' do
      sign_in user1

      visit questions_path

      click_on 'Edit'

      within '.questions' do
        fill_in 'Your Question body', with: ''
        click_on 'Save'
      end
      expect(page).to have_content 'Body can\'t be blank'
    end

    scenario "tries to edit other user's answer" do
      sign_in user2

      visit questions_path

      expect(page).to_not have_link 'Edit'
    end
  end
end
