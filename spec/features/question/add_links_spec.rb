require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { FactoryBot.create(:user) }
  given(:gist_url_1) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:gist_url_2) { 'https://gist.github.com/40grivenprog/4054b53640f9ea854b6082eca4a43f5b' }

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist 1'
    fill_in 'Link url', with: gist_url_1

    click_on 'Add one more link'

    within(:xpath, "//div[@class = 'nested-fields'][2]") do
      fill_in 'Link name', with: 'My gist 2'
      fill_in 'Link url', with: gist_url_2
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist 1', href: gist_url_1
    expect(page).to have_link 'My gist 2', href: gist_url_2
  end
end
