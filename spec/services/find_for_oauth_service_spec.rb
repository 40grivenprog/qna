require 'rails_helper'

RSpec.describe FindForOauthService  do
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
  subject { FindForOauthService.new(auth) }
  context 'user already has authorization' do
    let!(:user) {FactoryBot.create(:user) }
    it 'returns the user' do
      user.authorizations.create(provider: 'facebook', uid: '123456')
      expect(subject.call).to eq user
    end
  end

  context 'user has not authorization' do
    context 'user already exists' do
      let!(:user) {FactoryBot.create(:user) }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email}) }
      it 'does not create new user' do
        expect { subject.call.to_not change(User, :count) }
      end

      it 'creates new record in authorizations' do
        expect { subject.call }.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        user = subject.call
        authorization = user.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'reruns the user' do
        expect(subject.call).to eq user
      end
    end

    context 'user does not exist' do
      let(:user) {FactoryBot.create(:user) }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email}) }

      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end
      it 'returns new user' do
        expect(subject.call).to be_a(User)
      end
      it 'fills user email' do
        user = subject.call
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates authorization with provider and uid' do
        user = subject.call
        authorization = user.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end
end
