require 'rails_helper'

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

      visit question_path(question)

      click_on 'Delete'
      expect(page).to have_content('Destroyed successfully')
    end

    scenario 'User removes not his answer' do
      sign_in(user2)

      visit visit question_path(question)

      click_on 'Delete'
      expect(page).to have_content('You are not the author')
    end
  end

  scenario 'user removes answer' do
    visit  question_path(question)

    click_on 'Delete'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end