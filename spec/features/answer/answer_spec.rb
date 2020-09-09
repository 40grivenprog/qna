require 'rails_helper'

feature 'User can write an answer', %q{
  In order to help another user from a community
  As an authencated User
  I'd like to be able to write an answer and see another answers for a question
} do

  given(:user) { FactoryBot.create(:user) }
  given(:question) { FactoryBot.create(:question) }
  given(:answer) { FactoryBot.create(:answer) }

  describe 'Authenticated user' do
    background { sign_in user}

    background { visit question_path(question) }

    scenario 'write an answer with valid params' do
      fill_in 'Body', with: answer.body
      click_on 'Make Answer'

      expect(page).to have_content answer.body
    end

    scenario 'write an answer with invalid params' do
      click_on 'Make Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user write an answer' do
    visit question_path(question)

    click_on 'Make Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
