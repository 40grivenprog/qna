require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given(:user1) { FactoryBot.create(:user) }
  given(:user2) { FactoryBot.create(:user) }
  given(:question) { FactoryBot.create(:question, user: user1) }
  given!(:answer) { FactoryBot.create(:answer, question: question, user: user1) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true  do
    scenario 'edits his answer' do
      sign_in user1
      visit question_path(question)

      click_on 'Edit'


      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      sign_in user1
      visit question_path(question)

      click_on 'Edit'


      within '.answers' do
        fill_in 'Your answer', with: 'abc'

        click_on 'Save'
      end

      expect(page).to have_content 'Body is too short'
      expect(page).to have_selector 'textarea'
    end

    scenario 'add attached files to answer while editing' do
      sign_in user1

      visit question_path(question)

      click_on 'Edit'
      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in user2

      visit question_path(question)

      expect(page).to_not have_selector(:link_or_button, 'Edit')
    end
  end
end
