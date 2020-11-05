require 'rails_helper'

feature 'User can add comments to answer', %q{
  In order to give mare information about answer
  As an authenticad user
  I'd like to be able to add comments
} do
  given(:user) { FactoryBot.create(:user) }
  given(:question) { FactoryBot.create(:question) }
  given!(:answer) { FactoryBot.create(:answer, question: question)}

  scenario 'User adds comment', js: true do
    sign_in(user)
    visit question_path(question)

    within ".answer_#{answer.id}_comments" do
      fill_in 'Body', with: 'Nice answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Add comment'

      expect(page).to have_content('Nice answer')
      expect(page).to have_link 'rails_helper.rb'
    end
  end

  scenario 'User destroys links from comment' do

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
        within ".answer_#{answer.id}_comments" do
          fill_in 'Body', with: 'Nice answer'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Add comment'

          expect(page).to have_content('Nice answer')
          expect(page).to have_link 'rails_helper.rb'
        end
      end

      Capybara.using_session('guest') do
        within ".answer_#{answer.id}_comments" do
          expect(page).to have_content('Nice answer')
          expect(page).to have_link 'rails_helper.rb'
        end
      end
    end
  end
end
