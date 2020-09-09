require 'rails_helper'

feature 'User can sign in', %q{
  In order to get an answer from a community
  As an authencated User
  I'd like to be able to ask a question
} do

  given(:user) { FactoryBot.create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Question'
      fill_in 'Body', with: 'Question body'
      click_on 'Ask'
      expect(page).to have_content 'Your question succesfully created.'
      expect(page).to have_content 'Question'
      expect(page).to have_content 'Question body'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthencated user asks a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

feature 'User can delete a question if user is an author', %q{
  In order to help another users from a community a want to remove my question if it's incorrect
  As an authencated User
  I'd like to be able to remove my questions
} do

  given(:user1) { FactoryBot.create(:user) }
  given(:user2) { FactoryBot.create(:user) }
  given!(:question) { FactoryBot.create(:question, user: user1) }

  describe 'Authenticated user' do
    scenario 'User removes his questions' do
      sign_in(user1)

      visit questions_path

      click_on 'Delete'
      expect(page).not_to have_content(question.title)
    end

    scenario 'User removes not his question' do
      sign_in(user2)

      visit questions_path

      click_on 'Delete'
      expect(page).to have_content('You are not the author')
    end
  end

  scenario 'user removes question' do
    visit questions_path

    click_on 'Delete'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end