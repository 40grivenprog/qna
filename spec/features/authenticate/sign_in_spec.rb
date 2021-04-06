require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthencated User
  I'd like to be able to sign in
} do

  given(:user) { FactoryBot.create(:user) }
  given(:github_user) { FactoryBot.create(:user, email: 'github@user.com')}

  background { visit new_user_session_path }

  scenario 'Registered user try to sign in' do

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Log In'

    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'Unregistered user try to sign in' do

    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'

    click_on 'Log In'

    expect(page).to have_content 'Invalid Email or password.'

  end
end
