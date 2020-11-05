require 'rails_helper'

feature 'User can add comments to question', %q{
  In order to give mare information about question
  As an authenticad user
  I'd like to be able to add comments
} do
  given(:user) { FactoryBot.create(:user) }
  given(:question) { FactoryBot.create(:question) }

  scenario 'User adds comment', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question_comments' do
      fill_in 'Body', with: 'Nice question'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Add comment'

      expect(page).to have_content('Nice question')
      expect(page).to have_link 'rails_helper.rb'
    end
  end

  context "multiple sessions", :cable do
    scenario "all users see new question in real-time", js: true  do
      Capybara.using_session('author') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('author') do
        within '.question_comments' do
          fill_in 'Body', with: 'Nice question'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Add comment'

          expect(page).to have_content('Nice question')
          expect(page).to have_link 'rails_helper.rb'
        end
      end

      Capybara.using_session('guest') do
        within '.question_comments' do
          expect(page).to have_content('Nice question')
          expect(page).to have_link 'rails_helper.rb'
        end
      end
    end
  end
end
