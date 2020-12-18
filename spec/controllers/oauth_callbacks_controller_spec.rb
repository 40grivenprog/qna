require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { {'provider' => 'github', 'uid' => 123 } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
         expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path if user exist' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user if it is not exist' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Vkontakte' do
    let(:oauth_data) { OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
                                                                                      :provider => 'vkontakte',
                                                                                      :uid => '123545',
                                                                                      :info => {
                                                                                        email: 'example@gmail.com'
                                                                                      }
                                                                                    }) }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :vkontakte
    end

    context 'user exists' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :vkontakte
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
         expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        allow(User).to receive(:find_for_oauth)
        get :vkontakte
      end

      it 'redirects to root path if user exist' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user if it is not exist' do
        expect(subject.current_user).to_not be
      end
    end
  end
end
