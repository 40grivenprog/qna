require 'rails_helper'

feature 'User can Deletes for an answer if user is an author', %q{
  In order to help another users from a community a want to remove attached files from my answer if not needed
  As an authencated User
  I'd like to be able to remove my attached files to my answer
} do

  given(:user1) { FactoryBot.create(:user) }
  given(:user2) { FactoryBot.create(:user) }
  given!(:question) { FactoryBot.create(:question, user: user1) }
  given!(:answer) { FactoryBot.create(:answer, :with_file, user: user1, question: question) }

  describe 'Aunthencated user', js: true do
    scenario 'removes attached files if he is an author of an answer' do
      sign_in(user1)
      visit question_path(question)

      within('.answer-files-list') do
        click_on 'Delete'

        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'removes attached files if he is not an author of an answer' do
      sign_in(user2)

      visit question_path(question)

      within '.answer-files-list' do
        expect(page).to_not have_selector(:link_or_button, 'Delete')
      end
    end
  end

  scenario 'user removes attached file' do
    visit question_path(question)

    within '.answer-files-list' do
      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end
  end

end
