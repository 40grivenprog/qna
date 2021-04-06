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
      click_on 'Add question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Question'
      fill_in 'Body', with: 'Question body'
      click_on 'Ask'
      expect(page).to have_content 'Your question succesfully created.'
      expect(page).to have_content 'Question'
      expect(page).to have_content 'Question body'
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Question'
      fill_in 'Body', with: 'Question body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    context "multiple sessions", :cable do
      scenario "all users see new question in real-time", js: true  do
        Capybara.using_session('author') do
          sign_in(user)
          visit questions_path
        end

        Capybara.using_session('guest') do
          visit questions_path
        end

        Capybara.using_session('author') do
          visit new_question_path
          fill_in 'Title', with: 'Question'
          fill_in 'Body', with: 'Question body'

          click_on 'Ask'

          expect(page).to have_content 'Question'
          expect(page).to have_content 'Question body'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Question'
        end
      end
    end
  end

  scenario 'Unauthencated user asks a question' do
    visit questions_path
    click_on 'Add question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
