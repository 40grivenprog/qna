# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
  describe 'Github' do
    let(:oauth_data) do
      OmniAuth::AuthHash.new({
                               provider: 'vkontakte',
                               uid: '123545',
                               info: {
                                 email: 'example@gmail.com'
                               }
                             })
    end

    let(:service) { FindForOauthService.new(oauth_data) }

    it 'finds user from oauth data' do
      allow(FindForOauthService).to receive(:new).and_return(service)
      expect(service).to receive(:call)
      get :github
    end

    context 'user exists' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        allow(FindForOauthService).to receive(:new).and_return(service)
        allow(service).to receive(:call).and_return(user)
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
        allow(FindForOauthService).to receive(:new).and_return(service)
        allow(service).to receive(:call)
        get :github
      end

      it 'redirects to root path if user not exists' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user if it is not exists' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Vkontakte' do
    let(:oauth_data_with_email) do
      OmniAuth.config.mock_auth[:vlontakte] = OmniAuth::AuthHash.new({
                                                                       provider: 'vkontakte',
                                                                       uid: '123545',
                                                                       info: {
                                                                         email: 'example@gmail.com'
                                                                       }
                                                                     })
    end

    let(:oauth_data_without_email) do
      OmniAuth.config.mock_auth[:vlontakte] = OmniAuth::AuthHash.new({
                                                                       provider: 'vkontakte',
                                                                       uid: '123545',
                                                                       info: {
                                                                         email: nil
                                                                       }
                                                                     })
    end

    let(:service) { FindForOauthService.new(oauth_data_with_email) }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_without_email)
      allow(FindForOauthService).to receive(:new).and_return(service)
      expect(service).to receive(:call)
      get :vkontakte
    end

    context 'user exists' do
      let(:user) { FactoryBot.create(:user) }

      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_without_email)
        allow(FindForOauthService).to receive(:new).and_return(service)
        allow(service).to receive(:call).and_return(user)
        get :vkontakte
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user not exists and outh didn\'t return email' do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_without_email)
        get :vkontakte
      end

      it 'redirect_to new_user_confirmation_path' do
        expect(response).to redirect_to(new_user_confirmation_path)
      end
    end

    context 'user does not exist' do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_with_email)
        allow(FindForOauthService).to receive(:new).and_return(service)
        allow(service).to receive(:call)
        get :vkontakte
      end

      it 'redirects to root path if user not exists' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user if it is not exists' do
        expect(subject.current_user).to_not be
      end
    end
  end
end
