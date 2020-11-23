require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    it 'finds user from oauth data' do
      expect(User).to receive(:find_for_oauth)
      get :github
    end

    it 'redirects to root path if user exist' do
      allow(User).to receive(:find_for_oauth)
      get :github

      expect(response).to redirect_to root_path
    end

    it 'login user if it is exist'
    it 'does not login user if it is not exist'
  end
end
