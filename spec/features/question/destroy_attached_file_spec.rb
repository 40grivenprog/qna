require 'rails_helper'

feature 'User can delete attached files for a question if user is an author', %q{
  In order to help another users from a community a want to remove attached files from my question if not needed
  As an authencated User
  I'd like to be able to remove my attached files to my questions
} do
  given(:user1) { FactoryBot.create(:user) }
  given(:user2) { FactoryBot.create(:user) }
  given!(:question) { FactoryBot.create(:question, :with_file, user: user1) }

  describe 'Authencated user', js: true do
    scenario 'removes attached files if he is an author of a question' do
      sign_in(user1)

      visit question_path(question)

      within '.question' do
        click_on 'Delete'

        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'removes attached files if he is not an author of a question' do
      sign_in(user2)

      visit question_path(question)

      within '.question' do
        expect(page).to_not have_selector(:link_or_button, 'Delete')
      end
    end
  end

  scenario 'user removes attached file' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end
  end
end
