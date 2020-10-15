require 'rails_helper'

feature 'User can choose the best answer for his question', %q{
  In order to help another user from a community
  As an authencated User
  I'd like to be able to choose answer that helped me and mark it as best answer
} do

  given(:user1) { FactoryBot.create(:user) }
  given(:user2) { FactoryBot.create(:user) }
  given(:question) { FactoryBot.create(:question, user: user1) }
  given!(:answer) { FactoryBot.create(:answer, question: question, user: user1) }

  describe 'Authenticated user', js: true do
    scenario 'user is author of a question' do
      sign_in(user1)

      visit question_path question

      click_on 'Mark as best'

      within '.best_answer' do
          expect(page).to have_content (answer.body)
      end
    end

    scenario 'user is not author of a question' do
      sign_in(user2)

      visit question_path question

      expect(page).to_not have_selector(:link_or_button, 'Mark as best')
    end
  end

  scenario 'user marks as best answer' do
    visit  question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Mark as best')
  end
end
