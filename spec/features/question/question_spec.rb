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