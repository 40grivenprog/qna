require 'rails_helper'

feature 'User can write an answer', %q{
  In order to help another user from a community
  As an authencated User
  I'd like to be able to write an answer and see another answers for a question
} do

  given(:user) { FactoryBot.create(:user) }
  given(:question) { FactoryBot.create(:question) }

  describe 'Authenticated user', js: true do
    background { sign_in user}

    background { visit question_path(question) }

    scenario 'write an answer with valid params' do
      fill_in 'Body', with: 'This is Answer'

      click_on 'Make Answer'

      expect(page).to have_content 'This is Answer'
    end

    scenario 'write an answer with attached files' do
      fill_in 'Body', with: 'This is Answer'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Make Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'write an answer with invalid params', js: true do
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
