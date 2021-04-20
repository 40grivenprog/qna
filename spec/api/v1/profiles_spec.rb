# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
      { 'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json' }
    end

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { FactoryBot.create(:user) }
      let(:access_token) { FactoryBot.create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/other' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/other' }
    end

    context 'authorized' do
      let(:me) { FactoryBot.create(:user) }
      let!(:another_user) { FactoryBot.create(:user)}
      let(:access_token) { FactoryBot.create(:access_token, resource_owner_id: me.id) }
      let(:users_response) { json['users'].first }

      before { get '/api/v1/profiles/other', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return only another user' do
        expect(json['users'].size).to eq 1
      end

      it 'returns all public fields for another_user' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(users_response[attr]).to eq another_user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
end
