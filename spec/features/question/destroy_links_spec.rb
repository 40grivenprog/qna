require 'rails_helper'

feature 'User can delete links from question', %q{
  In order to destroy additional info to my question
  As an question's author
  I'd like to be able to delete links
} do
  given(:user1) { FactoryBot.create(:user) }
  given(:user2) { FactoryBot.create(:user) }
  given!(:question) { FactoryBot.create(:question, user: user1) }
  given!(:link) { FactoryBot.create(:link, linkable: question) }

  describe 'authenticate user', js: true do
    scenario 'destroys links for his question' do
      sign_in(user1)
      visit question_path(question)
      within '.links-list' do
        click_on 'Delete'
        expect(page).to_not have_content(link.name)
      end
    end

    scenario 'destroys links not for his question' do
      sign_in(user2)
      visit question_path(question)
      within '.links-list' do
        expect(page).to_not have_link('Delete')
      end
    end
  end
end
