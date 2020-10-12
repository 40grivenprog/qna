require 'rails_helper'

feature 'User can delete links from answer', %q{
  In order to destroy additional info to my answer
  As an answer's author
  I'd like to be able to delete links
} do
  given(:user1) { FactoryBot.create(:user) }
  given(:user2) { FactoryBot.create(:user) }
  given(:question) { FactoryBot.create(:question, user: user1) }
  given!(:answer) { FactoryBot.create(:answer, question: question, user: user1) }
  given!(:link) { FactoryBot.create(:link, :for_answer, linkable: answer) }

  describe 'authenticate user', js: true do
    scenario 'destroys links for his answer' do
      sign_in(user1)
      visit question_path(question)
      within '.answer-links-list' do
        click_on 'Delete'
        expect(page).to_not have_content(link.name)
      end
    end

    scenario 'destroys links not for his answer' do
      sign_in(user2)
      visit question_path(question)
      within '.answer-links-list' do
        expect(page).to_not have_link('Delete')
      end
    end
  end
end
