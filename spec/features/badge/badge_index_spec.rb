require 'rails_helper'

feature 'User can check his badges', %q{
  In order to check his badges
  As an authenticated user
  I'd like to be able to see my badges
} do

  given(:user) { FactoryBot.create(:user) }
  given!(:question) { FactoryBot.create(:question) }
  given(:answer) { FactoryBot.create(:answer)}
  given!(:badge) { FactoryBot.create(:badge, user: user, question: question)}

  scenario 'Authenticated user check his badges' do
    sign_in(user)

    visit badges_path

    expect(page).to have_content(badge.title)
    expect(page).to have_content(badge.question.title)
    expect(page).to have_xpath("//img")
  end

  scenario 'Unauthenticated user check his badges' do
    visit badges_path

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
