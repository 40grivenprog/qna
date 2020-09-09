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

feature 'User can delete an answer if user is an author', %q{
  In order to help another users from a community i want to remove my answer if it's incorrect
  As an authencated User
  I'd like to be able to remove my answer
} do

  given(:user1) { FactoryBot.create(:user) }
  given(:user2) { FactoryBot.create(:user) }
  given(:question) { FactoryBot.create(:question, user: user1) }
  given!(:answer) { FactoryBot.create(:answer, question: question, user: user1) }


  describe 'Authenticated user' do
    scenario 'User removes his answer' do
      sign_in(user1)

      visit question_answers_path(question_id: question)

      click_on 'Delete'
      expect(page).to have_content('Destroyed succesfully')
    end

    scenario 'User removes not his answer' do
      sign_in(user2)

      visit question_answers_path(question_id: question)

      click_on 'Delete'
      expect(page).to have_content('You are not the author')
    end
  end

  scenario 'user removes answer' do
    visit questions_path

    click_on 'Delete'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end