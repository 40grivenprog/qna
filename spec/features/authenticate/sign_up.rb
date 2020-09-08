require 'rails_helper'

feature 'User can sign up', %q{
  In order if i haven't got account
  As an unauthencated User
  I'd like to be able to sign up
}do

  given(:user) { FactoryBot.create(:user) }

  scenario "User try to sign up with valid params" do
    visit new_user_registration_path

    fill_in 'Email', with: 'valid@test.com'
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  scenario "User try to sign up with invalid params" do
    visit new_user_registration_path

    click_on 'Sign up'

    expect(page).to have_content("Email can't be blank")
  end

end