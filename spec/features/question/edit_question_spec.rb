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

    expect(page).to_not have_link id: "edit-#{question.id}-question"
  end

  describe 'Authenticated user', js: true  do
    scenario 'edits his answer' do
      sign_in user1

      visit questions_path

      click_on id: "edit-#{question.id}-question"

      within '.questions' do
        fill_in 'Your Question title', with: 'edited question title'
        fill_in 'Your Question body', with: 'edited question body'

        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to_not have_selector 'edited question body'
      end
    end

    scenario 'add attached files to question while editing' do
      sign_in user1

      visit questions_path

      click_on  id: "edit-#{question.id}-question"

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Save'

      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'add links to question while editing', js: true do
      sign_in user1

      visit questions_path

      click_on  id: "edit-#{question.id}-question"
      click_on 'Add one more link'

      fill_in 'Link name', with: 'Google Link'
      fill_in 'Link url', with: 'https://www.google.com/'

      click_on 'Save'

      visit question_path(question)

      expect(page).to have_link 'Google Link', href: 'https://www.google.com/'
    end

    scenario 'edits his answer with errors' do
      sign_in user1

      visit questions_path

      click_on  id: "edit-#{question.id}-question"

      within '.questions' do
        fill_in 'Your Question body', with: ''
        click_on 'Save'
      end
      expect(page).to have_content 'Body can\'t be blank'
    end

    scenario "tries to edit other user's answer" do
      sign_in user2

      visit questions_path

      expect(page).to_not have_link id: "edit-#{question.id}-question"
    end
  end
end
