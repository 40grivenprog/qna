require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { FactoryBot.create(:user) }
  given!(:question) { FactoryBot.create(:question) }
  given(:gist_url_1) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:gist_url_2) { 'https://gist.github.com/40grivenprog/4054b53640f9ea854b6082eca4a43f5b' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'My gist 1'
    fill_in 'Link url', with: gist_url_1

    click_on 'Add one more link'

    within(:xpath, "//div[@class = 'nested-fields'][2]") do
      fill_in 'Link name', with: 'My gist 2'
      fill_in 'Link url', with: gist_url_2
    end

    click_on 'Make Answer'

    within '.answers' do
      expect(page).to have_link 'My gist 1', href: gist_url_1
      expect(page).to have_link 'My gist 1', href: gist_url_1
    end
  end

end
