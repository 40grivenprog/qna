require 'rails_helper'

feature 'User can sign out', %q{
  In order if i have more that one account
  I'd like to be able to sign out
} do

  given(:user) { FactoryBot.create(:user) }

  background { sign_in user }

  scenario 'Authenticated user sign out' do
    click_on 'Log Out'
    expect(page).to have_content 'Signed out successfully.'
  end
end